from marshmallow import Schema, fields, post_load, validates, ValidationError
from app.models import User, Book, Bookmark, Library, Category, Store, Note
from app import db
from datetime import datetime
import base64


#--------------------
# User
#--------------------
class UserSchema(Schema):

    id = fields.Int(dump_only=True)
    username = fields.Str(required=True)
    email = fields.Email(required=True)
    phone = fields.Str(required=True)
    role = fields.Str(default='user', dump_only=True)  # Lecture seule
    status = fields.Str(default='active', dump_only=True)  # Lecture seule
    full_name = fields.Str(allow_none=True)
    profile_image = fields.URL(allow_none=True)
    reading_preferences = fields.Str(allow_none=True)  # Préférences utilisateur
    purchase_history = fields.List(fields.Dict(), dump_only=True)  # Historique des achats (lecture seule)
    library = fields.List(fields.Nested('BookSchema', only=('id', 'title', 'author')), dump_only=True, required=False)
    bookmarks = fields.List(fields.Nested('BookmarkSchema', only=('id', 'page_number', 'book_id')), dump_only=True, required=False)
    notes = fields.List(fields.Nested('NoteSchema', only=('id', 'content', 'book_id')), dump_only=True, required=False)
    password = fields.Str(load_only=True, required=True)  # Non sérialisé pour des raisons de sécurité

    @post_load
    def make_user(self, data, **kwargs):
        """
        Crée un objet `User` à partir des données désérialisées.
        Hash le mot de passe avant de créer l'utilisateur.
        """
        password = data.pop('password', None)
        user = User(**data)
        if password:
            user.set_password(password)
        return user

    @validates('username')
    def validate_username(self, value):
        """Validation du champ `username` pour garantir l'unicité."""
        if User.query.filter_by(username=value).first():
            raise ValidationError("Le nom d'utilisateur est déjà utilisé.")

    @validates('email')
    def validate_email(self, value):
        """Validation du champ `email` pour garantir l'unicité."""
        if User.query.filter_by(email=value).first():
            raise ValidationError("L'adresse email est déjà utilisée.")

    def save(self, user):
        """
        Sauvegarde un objet `User` dans la base de données.
        """
        db.session.add(user)
        db.session.commit()

    def delete(self, user):
        """
        Supprime un objet `User` de la base de données.
        """
        db.session.delete(user)
        db.session.commit()


#--------------------
# Book
#--------------------
class BookSchema(Schema):
    id = fields.Int(dump_only=True)
    title = fields.Str(required=True)
    author = fields.Str(required=True)
    genre = fields.Str(required=True)
    publication_date = fields.DateTime(default=datetime.now)
    ISBN = fields.Str(required=True)
    cover_image = fields.Str(load_only=True)
    description = fields.Str()
    file_url = fields.Str()
    file = fields.Raw(load_only=True)
    price = fields.Float(required=True)
    nbr_page = fields.Int()
    popularity = fields.Float()
    reading = fields.Bool(default=False)
    nbr_chapter = fields.Int()
    language = fields.Str()
    publisher = fields.Str()
    file_format = fields.Str()
    file_size = fields.Float()
    tags = fields.Str()
    reviews = fields.List(fields.Nested('ReviewSchema', exclude=('book',)))  # Liste de reviews liées
    categories = fields.List(fields.Str())  # Liste de catégories sous forme de noms de catégorie
    users = fields.List(fields.Nested('UserSchema', exclude=('library',)))

    @post_load
    def make_book(self, data, **kwargs):
        """Désérialiser et renvoyer un objet Book à partir des données"""
        return Book(**data)


#----------------------
# Category
#----------------------
class CategorySchema(Schema):
    id = fields.Int(dump_only=True)
    name = fields.Str(required=True)
    description = fields.Str()
    popularity = fields.Float()
    cover_image = fields.Str()
    cover_image_data = fields.Raw(load_only=True)  # Données binaires de l'image (BLOB)

    # Liste des livres associés à cette catégorie
    books = fields.List(fields.Nested('BookSchema', exclude=('categories',)))  # Exclure le champ 'categories' dans BookSchema pour éviter la récursivité

    @post_load
    def make_category(self, data, **kwargs):
        """Désérialiser et renvoyer une instance de Category"""
        return Category(**data)

    def get_cover_image_data(self, obj):
        """Convertir les données binaires de l'image en Base64 pour l'inclure dans la réponse JSON"""
        if obj.cover_image_data:
            return base64.b64encode(obj.cover_image_data).decode('utf-8')  # Encodage en Base64
        return None



#--------------------
# store 
#--------------------
class StoreSchema(Schema):
    id = fields.Int(dump_only=True)
    promotions = fields.Str()
    user_reviews = fields.Str()
    best_sellers = fields.Str()
    new_releases = fields.Str()

    # Liste des livres associés à ce store
    available_books = fields.List(fields.Nested('BookSchema', exclude=('store',)))  # Exclure 'store' pour éviter récursivité

    @post_load
    def make_store(self, data, **kwargs):
        """Désérialiser et renvoyer une instance de Store"""
        return Store(**data)

#--------------------
# Note 
#--------------------
class NoteSchema(Schema):
    id = fields.Int(dump_only=True)
    text = fields.Str(required=True)
    page_number = fields.Int(required=True)
    date_created = fields.DateTime(dump_only=True)
    book_id = fields.Int(required=True)
    user_id = fields.Int(required=True)

    # Définir des relations pour sérialiser les objets associés
    book = fields.Nested('BookSchema', only=('id', 'title'))
    user = fields.Nested('UserSchema', only=('id', 'username'))

    @post_load
    def make_note(self, data, **kwargs):
        """Désérialiser et renvoyer une instance de Note"""
        return Note(**data)

#--------------------
# Bookmark page
#--------------------
class BookmarkSchema(Schema):
    id = fields.Int(dump_only=True)
    page_number = fields.Int(required=True)
    date_created = fields.DateTime(dump_only=True)
    book_id = fields.Int(required=True)
    user_id = fields.Int(required=True)

    # Définir des relations pour sérialiser les objets associés
    book = fields.Nested('BookSchema', only=('id', 'title'))
    user = fields.Nested('UserSchema', only=('id', 'username'))

    @post_load
    def make_bookmark(self, data, **kwargs):
        """Désérialiser et renvoyer une instance de Bookmark"""
        return Bookmark(**data)

#--------------------
# Library
#--------------------

class LibrarySchema(Schema):
    id = fields.Int(dump_only=True)
    last_accessed = fields.DateTime(dump_only=True)
    user_id = fields.Int(required=True)

    # Définir des relations pour sérialiser les objets associés
    books = fields.List(fields.Nested('BookSchema', only=('id', 'title')))
    categories = fields.List(fields.Nested('CategorySchema', only=('id', 'name')))
    user = fields.Nested('UserSchema', only=('id', 'username'))

    @post_load
    def make_library(self, data, **kwargs):
        """Désérialiser et renvoyer une instance de Library"""
        return Library(**data)