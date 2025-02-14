from flask import Blueprint, jsonify, request, send_file
from app import db
from io import BytesIO
from app.models import User, Category
from app.serialization import UserSchema, CategorySchema
from flask_jwt_extended import jwt_required
import base64


routes = Blueprint('routes', __name__)

@routes.route('/users', methods=['GET'])
@jwt_required()
def get_users():
    page = request.args.get('page', default=1, type=int)
    per_page = request.args.get('per_page', default=3, type=int)
    users = User.query.paginate(
        page=page,
        per_page=per_page,
    )  # Récupérer tous les utilisateurs

    user_schema = UserSchema(many=True)  # Créer un schéma pour plusieurs utilisateurs

    result = user_schema.dump(users)
    return jsonify({
        "users":result
    })  # Sérialisation et envoi des utilisateurs en JSON

@routes.route('/users/<int:user_id>', methods=['GET'])
# @jwt_required()
def get_user_by_id(user_id):
    user = User.query.get(user_id)
    if user:
        user_schema = UserSchema()  # Créer un schéma pour un seul utilisateur
        user_data = user_schema.dump(user)  # Sérialisation de l'utilisateur
        # Inclure ici le mot de passe dans la réponse
        user_data['password'] = user.password_hash  # Ajouter le mot de passe à la réponse
        return jsonify(user_data)  # Renvoyer les données de l'utilisateur avec le mot de passe
    return jsonify({"error": "User not found"}), 404


@routes.route('/users/<string:username>', methods=['GET'])
def get_username(username):
    user = User.get_by_username(username)
    if user:
        user_schema = UserSchema()  # Créer un schéma pour un seul utilisateur
        user_data = user_schema.dump(user)  # Sérialisation de l'utilisateur
        # Inclure ici le mot de passe dans la réponse
        # user_data['password'] = user.password_hash  # Ajouter le mot de passe à la réponse
        return jsonify(user_data)  # Renvoyer les données de l'utilisateur avec le mot de passe
    return jsonify({"error": "User not found"}), 404

@routes.route('/users/phone/<string:phone>', methods=['GET'])
def get_by_phone(phone):
    user = User.get_by_phone(phone)
    if user:
        user_schema = UserSchema()  # Créer un schéma pour un seul utilisateur
        user_data = user_schema.dump(user)  # Sérialisation de l'utilisateur
        # Inclure ici le mot de passe dans la réponse
        # user_data['password'] = user.password_hash  # Ajouter le mot de passe à la réponse
        return jsonify(user_data)  # Renvoyer les données de l'utilisateur avec le mot de passe
    return jsonify({"error": "User not found"}), 404


@routes.route('/users/<int:user_id>', methods=['PUT'])
# @jwt_required()
def update_user(user_id):
    # Récupérer l'utilisateur depuis la base de données
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    # Récupérer les données de la requête
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data provided"}), 400

    # Si un mot de passe est fourni, il doit être haché avant de l'enregistrer
    if 'password' in data:
        password = data.get('password')  # Get 'password' des données
        # Hacher et mettre à jour le mot de passe
        user.password = data.get('password' , user.set_password(password))

    # Mettre à jour tous les champs fournis dans la requête
    user.username = data.get('username', user.username)
    user.email = data.get('email', user.email)
    user.phone = data.get('phone', user.phone)
    user.role = data.get('role', user.role)
    user.status = data.get('status', user.status)
    user.full_name = data.get('full_name', user.full_name)
    user.profile_image = data.get('profile_image', user.profile_image)
    user.reading_preferences = data.get('reading_preferences', user.reading_preferences)
    user.purchase_history = data.get('purchase_history', user.purchase_history)

    # Les relations doivent être mises à jour avec précaution
    if 'library' in data:
        user.library = data['library']  # Assurez-vous que les IDs envoyés sont valides
    if 'bookmarks' in data:
        user.bookmarks = data['bookmarks']  # Assurez-vous que les données sont correctement formatées
    if 'notes' in data:
        user.notes = data['notes']  # Idem pour les notes

    try:
        # Sauvegarder les changements dans la base de données
        db.session.commit()
    except Exception as e:
        db.session.rollback()  # Annuler les changements en cas d'erreur
        return jsonify({"error": str(e)}), 500

    # Utiliser le schéma pour renvoyer l'objet mis à jour sous forme de JSON
    user_schema = UserSchema()
    updated_user = user_schema.dump(user)

    return jsonify({"message": "User updated successfully", "user": updated_user}), 200





@routes.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    user = User.query.get(user_id)  # Récupérer l'utilisateur avec l'ID spécifié
    if not user:
        return jsonify({"error": "User not found"}), 404  # Retourner une erreur si l'utilisateur n'existe pas

    db.session.delete(user)  # Supprimer l'utilisateur de la session
    db.session.commit()  # Valider la suppression dans la base de données

    return jsonify({"message": "User deleted"}), 200  # Retourner un message de succès


#--------------------
# Les methode pour Category 
#--------------------
@routes.route('/categories/create', methods=['POST'])
def add_category():
    """Ajouter une nouvelle catégorie avec une image"""
    data = request.form  # Récupérer les données envoyées via un formulaire
    if 'name' not in data:
        return jsonify({"error": "Le nom de la catégorie est obligatoire"}), 400

    name = data['name']
    description = data.get('description', "")
    popularity = data.get('popularity', 0.0)

    # Gérer l'image envoyée (si elle existe)
    cover_image = request.files.get('cover_image_data')  # Le champ 'cover_image' dans le formulaire
    cover_image_data = None
    cover_image_url = None

    if cover_image:
        print(cover_image)
        # Lire l'image sous forme binaire et convertir en base64
        cover_image_data = cover_image.read()


    # Ajouter la catégorie à la base de données
    try:
        # Charger les données dans le schéma Category
        category_schema = CategorySchema()
        new_category = category_schema.load({
            'name': name,
            'description': description,
            'popularity': popularity,
            'cover_image': cover_image.filename,  # Si vous utilisez un URL pour l'image
            'cover_image_data': cover_image_data  # Si vous utilisez les données binaires
        })

        db.session.add(new_category)
        db.session.commit()

        return jsonify({
            "message": "Catégorie ajoutée avec succès", 
            "category": new_category.cover_image 
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500


@routes.route('/categories', methods=['GET'])
def get_categories():
    """Lister toutes les catégories"""
    categories = Category.query.all()

    return jsonify({"categories": CategorySchema(many=True).dump(categories)}), 200


@routes.route('/categories/<int:category_id>', methods=['GET'])
def get_category(category_id):
    """Récupérer une catégorie par ID"""
    category = Category.query.get(category_id)
    if not category:
        return jsonify({"error": "Catégorie non trouvée"}), 404
    return jsonify(CategorySchema().dump(category)), 200


@routes.route('/categories/<int:category_id>/image', methods=['GET'])
def get_category_image(category_id):
    """Récupérer l'image d'une catégorie"""
    try:
        # Récupérer la catégorie par son ID
        category = Category.query.get_or_404(category_id)
        
        # Vérifier si l'image existe
        if category.cover_image_data:
            # Décoder les données de l'image en base64 et les convertir en binaire
            image_data = category.cover_image_data
            
            # Convertir les données binaires en fichier et le renvoyer
            return send_file(BytesIO(image_data), mimetype='image/png')
            # return send_file(BytesIO(image_data), download_name=category.cover_image, as_attachment=True)

        return jsonify({"error": "Aucune image trouvée pour cette catégorie"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@routes.route('/categories/update/<int:category_id>', methods=['PUT'])
def update_category(category_id):
    """Modifier une catégorie existante avec mise à jour de l'image de couverture"""
    category = Category.query.get(category_id)
    if not category:
        return jsonify({"error": "Catégorie non trouvée"}), 404

    # Récupérer les données du formulaire
    name = request.form.get('name', category.name)
    description = request.form.get('description', category.description)
    popularity = request.form.get('popularity', category.popularity)

    # Vérifier si une nouvelle image a été envoyée
    cover_image = request.files.get('cover_image_data')
    
    if cover_image:
        cover_image_data = cover_image.read()  # Lire l'image en binaire
        category.cover_image_data = cover_image_data  # Mettre à jour l'image

    # Mettre à jour les autres champs
    category.name = name
    category.description = description
    category.cover_image = cover_image.filename
    category.popularity = float(popularity) if popularity else category.popularity

    try:
        db.session.commit()
        return jsonify({
            "message": "Catégorie mise à jour avec succès",
            # "category": {
            #     "id": category.id,
            #     "name": category.name,
            #     "description": category.description,
            #     "popularity": category.popularity,
            #     # "cover_image_data": category.cover_image_data  # Image encodée en base64
            # }
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500


@routes.route('/categories/delete/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    category = Category.query.get(category_id)  # Récupérer le category avec l'ID spécifié
    if not category:
        return jsonify({"error": "Category not found"}), 404  # Retourner une erreur si l'utilisateur n'existe pas

    db.session.delete(category)  # Supprimer le category de la session
    db.session.commit()  # Valider la suppression dans la base de données

    return jsonify({"message": "Category deleted"}), 200  # Retourner un message de succès



