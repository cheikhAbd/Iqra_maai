from flask import Blueprint, request, jsonify
from app.models import Book, Category
from app import db
from app.serialization import BookSchema
import base64

# Création d'un Blueprint pour les routes des livres
book_bp = Blueprint('book_bp', __name__)

# Initialisation du schéma pour la sérialisation et désérialisation
book_schema = BookSchema()
books_schema = BookSchema(many=True)

# Route pour ajouter un livre
@book_bp.route('/books/create', methods=['POST'])
def add_book():
    """Ajouter un livre via une requête POST"""

    try:
        # Récupération des données envoyées via form-data
        title = request.form.get('title')
        author = request.form.get('author')
        genre = request.form.get('genre')
        publication_date = request.form.get('publication_date')
        ISBN = request.form.get('ISBN')
        description = request.form.get('description')
        price = request.form.get('price')
        nbr_page = request.form.get('nbr_page')
        popularity = request.form.get('popularity', 0.0)
        reading = request.form.get('reading', 'false').lower() == 'true'
        nbr_chapter = request.form.get('nbr_chapter')
        language = request.form.get('language')
        publisher = request.form.get('publisher')
        file_format = request.form.get('file_format')
        file_size = request.form.get('file_size')
        tags = request.form.get('tags')

        # Récupération des fichiers (image + fichier)
        cover_image = request.files.get('cover_image')
        file = request.files.get('file')

        cover_image_data = cover_image.read() if cover_image else None
        file_data = file.read() if file else None
        file_url = file.filename if file else None

        # Création du nouvel objet Book
        new_book = Book(
            title=title,
            author=author,
            genre=genre,
            publication_date=publication_date,
            ISBN=ISBN,
            cover_image=cover_image_data,
            description=description,
            file_url=file_url,
            file=file_data,
            price=price,
            nbr_page=nbr_page,
            popularity=float(popularity),
            reading=reading,
            nbr_chapter=nbr_chapter,
            language=language,
            publisher=publisher,
            file_format=file_format,
            file_size=file_size,
            tags=tags,
        )

        # Ajout des catégories si fournies
        category_ids = request.form.getlist('category_ids')
        if category_ids:
            new_book.add_to_categories(category_ids)

        # Sauvegarde en base de données
        db.session.add(new_book)
        db.session.commit()

        return jsonify({'message': 'Livre ajouté avec succès!', 'book': new_book.title}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 400


@book_bp.route('/books/<int:book_id>/add_to_categories', methods=['POST'])
def add_categories_to_book(book_id):
    """Ajouter des catégories à un livre existant"""
    book = Book.query.get(book_id)
    if not book:
        return jsonify({'message': 'Livre non trouvé'}), 404

    data = request.json
    category_ids = data.get('category_ids', [])

    if category_ids:
        book.add_to_categories(category_ids)
        return jsonify({'message': 'Catégories ajoutées avec succès', 'book': book.title}), 200
    return jsonify({'message': 'Aucune catégorie spécifiée'}), 400



@book_bp.route('/books/category/<string:category_name>', methods=['GET'])
def get_books_by_category(category_name):
    """Récupérer tous les livres d'une catégorie spécifique"""
    books = Book.get_books_by_category(category_name)
    
    if not books:
        return jsonify({"message": "Aucun livre trouvé pour cette catégorie"}), 404
    
    return jsonify(books_schema.dump(books)), 200



# routes Route pour récupérer tous les livres
@book_bp.route('/books', methods=['GET'])
def get_books():
    """Récupérer tous les livres"""
    books = Book.query.all()
    return jsonify(books_schema.dump(books)), 200


# routes Route pour récupérer un livre par son ID
@book_bp.route('/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    """Récupérer un livre par son ID"""
    book = Book.query.get(book_id)
    if not book:
        return jsonify({'message': 'Livre non trouvé'}), 404
    return jsonify(book_schema.dump(book)), 200


# routes Route pour mettre à jour un livre
@book_bp.route('/books/update/<int:book_id>', methods=['PUT'])
def update_book(book_id):
    """Mettre à jour un livre"""
    book = Book.query.get(book_id)
    if not book:
        return jsonify({'message': 'Livre non trouvé'}), 404

    # Gérer l'image envoyée (si elle existe)
    cover_image = request.files.get('cover_image')  # Le champ 'cover_image' dans le formulaire

    if cover_image:
        # Lire l'image sous forme binaire et convertir en base64
        cover_image = cover_image.read()
        book.cover_image = cover_image

    # Gérer le fichier envoyée (si elle existe)
    file_url = request.files.get('file')  # Le champ 'cover_image' dans le formulaire
    file = None

    if file_url :
        file = file_url.read()
        book.file = file

    data = request.json
    book.title = data.get('title', book.title)
    book.author = data.get('author', book.author)
    book.genre = data.get('genre', book.genre)
    book.publication_date = data.get('publication_date', book.publication_date)
    book.ISBN = data.get('ISBN', book.ISBN)
    book.description = data.get('description', book.description)
    book.file_url = file_url.filename
    book.nbr_page = data.get('nbr_page', book.nbr_page)
    book.popularity = data.get('popularity', book.popularity)
    book.reading = data.get('reading', book.reading)
    book.nbr_chapter = data.get('nbr_chapter', book.nbr_chapter)
    book.language = data.get('language', book.language)
    book.publisher = data.get('publisher', book.publisher)
    book.file_format = data.get('file_format', book.file_format)
    book.file_size = data.get('file_size', book.file_size)
    book.tags = data.get('tags', book.tags)

    db.session.commit()
    return jsonify(
        {'message': 'Livre mis à jour avec succès', 'book': book_schema.dump(book)}), 200


# routes Route pour supprimer un livre
@book_bp.route('/books/delete/<int:book_id>', methods=['DELETE'])
def delete_book(book_id):
    """Supprimer un livre"""
    book = Book.query.get(book_id)
    if not book:
        return jsonify({'message': 'Livre non trouvé'}), 404

    db.session.delete(book)
    db.session.commit()
    return jsonify({'message': 'Livre supprimé avec succès'}), 200
