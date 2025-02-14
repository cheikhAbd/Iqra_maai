from flask import Blueprint, jsonify, request, current_app
from app.models import User, OtpVerification
from app.serialization import UserSchema
from app import db
from flask_jwt_extended import (create_access_token, 
                                create_refresh_token, 
                                jwt_required,
                                get_jwt_identity,
                                get_jwt,
                                decode_token
                                )
from datetime import datetime, timedelta
import random
from twilio.rest import Client 
import time
import requests
from app.config import Config


auth_bp = Blueprint('auth',__name__)

 

#-----------------------
# Login to The App 
#-----------------
@auth_bp.post('/login')
def login_user():
    data = request.get_json()

    user = User.get_by_username(username=data.get('username'))

     # Recherche par username ou email
    user = User.query.filter(
        (User.username == data.get('username')) | (User.email == data.get('email')) | (User.phone == data.get('phone'))
    ).first()

    if user and user.check_password(password=data['password']):
        otp_code = send_sms(user.phone)
        if otp_code:
            return jsonify({"message": "OTP sent successfully"}), 200
        return jsonify({"message": "Failed to send OTP"}), 500
            
    return jsonify({'error':"Invalid username / email or password"}), 400


#------------------------
# refresh token
#------------------------
@auth_bp.get('/refresh')
@jwt_required(refresh=True)
def refresh_access():
    identify = get_jwt_identity()
    
    new_access_token = create_access_token(identity=identify)

    return jsonify({
        "access_token" : new_access_token
    })



#-----------------------
# Déconnexion 
#-----------------
blacklist = set()  # Liste noire pour stocker les tokens révoqués
@auth_bp.post('/logout')
@jwt_required()
def logout():
    jti = get_jwt()["jti"]  # Identifiant unique du token
    blacklist.add(jti)  # Ajouter le token à la liste noire
    print(blacklist)
    return jsonify({"messsage": "Déconnexion réussie"}), 200



#-----------------------
# Vérification de l'expiration du token
#-----------------
def is_token_expired():
    try:
        # Décodez le token et vérifiez son expiration
        token = request.headers.get('Authorization').split(" ")[1]
        decoded_token = decode_token(token, allow_expired=True)
        exp = decoded_token.get("exp")
        if not exp:
            return True
        return datetime.utcnow() > datetime.fromtimestamp(exp)
    except Exception as e:
        print(f"Erreur lors de la vérification de l'expiration : {e}")
        return True
    
#-------------------------------
# Rafraîchissement automatique du token
#-------------------------------

def ensure_valid_token(access_token, refresh_token):
    # Vérifiez si le token est expiré
    if is_token_expired():
        headers = {"Authorization": f"Bearer {refresh_token}"}
        try:
            # Effectuez une requête sortante vers le serveur
            response = requests.get('http://127.0.0.1:5000/auth/refresh', headers=headers)
            if response.status_code == 200:
                new_access_token = response.json().get("access_token")
                return new_access_token
        except requests.exceptions.RequestException as e:
            print(f"Erreur lors de la requête : {e}")
            return None
    return access_token


#--------------------------
# Route protégée utilisant la validation automatique du token
#--------------------------
@auth_bp.get('/protected')
@jwt_required()
def protected_route():
    access_token = request.headers.get('Authorization').split(" ")[1]
    refresh_token = request.cookies.get('refresh_token')

    valid_access_token = ensure_valid_token(access_token, refresh_token)
    if not valid_access_token:
        return jsonify({"error": "Unable to refresh token"}), 401

    return jsonify({"message": "Access granted", "access_token": valid_access_token})


#-------------------------
# Verfiy phone before logged in
#-------------------------
@auth_bp.post('/verify')
def verify_code():
    data = request.get_json()

    # Vérifier le code reçu
    phone_number = data.get('phone')
    code_entered = data.get('code')

    user = User.query.filter_by(phone=phone_number).first()
    otp_entry = OtpVerification.query.filter_by(phone=phone_number, otp_code=code_entered).first()

    if user :
        if not otp_entry or datetime.now() > otp_entry.expiry:
            return jsonify({"message": "Invalid or expired OTP!"}), 400

        access_token = create_access_token(identity=user.username)
        refresh_token = create_refresh_token(identity=user.username)

        return jsonify({
            "message": "Looged In",
            "tokens":{
                "access": access_token,
                "refresh":refresh_token
            }
        }), 200

    else:
        return jsonify({"message": "Invalid phone number!"}), 400


#-------------------------
# Verfiy phone before Reset Password
#-------------------------
@auth_bp.post('/verify_otp')
def verify_otp():
    data = request.get_json()

    # Vérifier le code reçu
    phone_number = data.get('phone')
    code_entered = data.get('otp')

    
    user = User.query.filter_by(phone=phone_number).first()
    otp_entry = OtpVerification.query.filter_by(phone=phone_number, otp_code=code_entered).first()

    if user :
        if not otp_entry or datetime.now() > otp_entry.expiry:
            return jsonify({"message": "Invalid or expired OTP!"}), 400

        return jsonify({
            "message": "OTP Verification Success"
        }), 200

    else:
        return jsonify({"message": "Invalid phone number!"}), 400

#------------------------------- 
# Send OTP to verfiy phone number before sign In
#---------------------    
def send_sms(phone, lang='ar'):
    url = f"https://chinguisoft.com/api/sms/validation/{Config.validation_key}"
    headers = {
        'Validation-token': Config.token,
        'Content-Type': 'application/json',
    }
    data = {
        'phone': phone,
        'lang': lang
    }
    
    try:
        response = requests.post(url, headers=headers, json=data)
        if response.status_code == 200:
            response_data = response.json()
            expiry_time = datetime.now() + timedelta(minutes=2)

            # Supprimer les OTP précédents pour ce numéro
            OtpVerification.query.filter_by(phone=phone).delete()

            # Enregistrer l'OTP dans la base de données
            otp_entry = OtpVerification(phone=phone, otp_code=response_data['code'], expiry=expiry_time)
            db.session.add(otp_entry)
            db.session.commit()
            

            print(f"SMS envoyé avec succès. Code : {response_data['code']}, Solde restant : {response_data['balance']}")
            return response_data['code']
        elif response.status_code == 422:
            errors = response.json().get('errors', {})
            print(f"Erreur de validation : {errors}")
            return None
        elif response.status_code == 429:
            print("Trop de requêtes, ralentissez.")
            return None
        elif response.status_code == 401:
            print("Clé ou token de validation invalide.")
            return None
        elif response.status_code == 402:
            print(f"Solde insuffisant. Message : {response.json().get('error')}")
            return None
        elif response.status_code == 503:
            print("Service temporairement indisponible.")
            return None
        else:
            print(f"Erreur inconnue. Statut : {response.status_code}, Réponse : {response.text}")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Erreur lors de l'appel à l'API ChinguiSoft : {e}")
        return None


#------------------------------- 
# Send OTP to verfiy phone number before register
#---------------------
@auth_bp.post('/send-otp')
def send_otp_route():
    data = request.get_json()
    phone_number = data.get('phone')

    if not phone_number:
        return jsonify({"message": "Phone number is required!"}), 400

    # Générer un OTP
    otp_code = send_sms(phone_number)
    if otp_code:
        return jsonify({"message": "OTP sent successfully", "code": otp_code}), 200
    return jsonify({"message": "Failed to send OTP"}), 500



#-------------------------------
# Register a new User
#---------------------
@auth_bp.post('/register')
def register_user():
    data = request.get_json()
    phone_number = data.get('phone')
    # Supprimer les champs non nécessaires
    otp_code = data.get('otp')
    data.pop('otp', None)
    data.pop('library', None)
    data.pop('bookmarks', None)
    data.pop('notes', None)
    

    # Vérifier si l'utilisateur existe déjà par username
    if User.get_by_username(username=data.get('username')):
        return jsonify({"message": "Username already exists!"}), 409

    # Vérifier si l'utilisateur existe déjà par email
    if User.query.filter_by(email=data.get('email')).first():
        return jsonify({"message": "Email already exists!"}), 409

    # Vérifier si l'utilisateur existe déjà
    if User.query.filter_by(phone=phone_number).first():
        return jsonify({"message": "Phone number already registered!"}), 409

    # Vérifier l'OTP
    otp_entry = OtpVerification.query.filter_by(phone=phone_number, otp_code=otp_code).first()
    if not otp_entry or datetime.now() > otp_entry.expiry:
        return jsonify({"message": "Invalid or expired OTP!"}), 400


    # Enregistrer l'utilisateur
    user_schema = UserSchema()
    new_user = user_schema.load(data)
    new_user.set_password(data['password'])

    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User created successfully!"}), 201
