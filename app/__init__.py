from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from app.config import Config
from flask_jwt_extended import JWTManager


db = SQLAlchemy()
migrate = Migrate()  # Initialisation de Flask-Migrate
jwt = JWTManager()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    db.init_app(app)
    migrate.init_app(app, db)  # Intégration de Flask-Migrate avec l'application et SQLAlchemy
    jwt.init_app(app=app) # Initialise JWT


    @jwt.unauthorized_loader
    def missing_token_callback(error):
        return jsonify({
            "message":"Request dosn't contain valid token",
            "error":f"Authorization_header",
        }), 401


    @jwt.expired_token_loader
    def expired_token_callback(jwt_header, jwt_data):
        return jsonify({
            "message":"Token has expired",
            "error":f"Token_expired",
        }), 401


    @jwt.invalid_token_loader
    def invalid_token_callback(error):
        return jsonify({
            "message":"Signature verfication failed",
            "error":f"Invalid_token",
        }), 401

    from app.auth import blacklist

    @jwt.token_in_blocklist_loader
    def check_if_token_revoked(jwt_header, jwt_payload):
        jti = jwt_payload["jti"]  # Identifiant unique du token
        return jti in blacklist


    with app.app_context():
        from app import routes  # Importer les routes
        db.create_all()
    return app
