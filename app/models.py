from app import db
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

# Table associative pour la relation entre Book et Category
book_category = db.Table(
    'book_category', db.Model.metadata,
    db.Column('book_id', db.Integer, db.ForeignKey('books.id'), primary_key=True),
    db.Column('category_id', db.Integer, db.ForeignKey('categories.id'), primary_key=True)
)

# Table associative pour la relation entre User et Book
book_user = db.Table(
    'book_user',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id'), primary_key=True),
    db.Column('book_id', db.Integer, db.ForeignKey('books.id'), primary_key=True)
)



class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)  # Hash du mot de passe
    phone = db.Column(db.String(20), unique=True, nullable=False)
    role = db.Column(db.String(20), default='user', nullable=False)  # Rôle (user, admin, etc.)
    status = db.Column(db.String(20), default='active', nullable=False)  # Statut (active, inactive, banned)
    full_name = db.Column(db.String(100), nullable=True)  # Nom complet
    profile_image = db.Column(db.String(255), nullable=True)  # URL de l'image de profil
    reading_preferences = db.Column(db.String(255), nullable=True)  # Préférences de lecture
    purchase_history = db.Column(db.JSON, nullable=True)  # Historique des achats (liste d'ID)
    
    # Relations
    library = db.relationship('Book', secondary=book_user, back_populates='users')  # Many-to-Many avec Book
    bookmarks = db.relationship('Bookmark', back_populates='user')  # One-to-Many avec Bookmark
    notes = db.relationship('Note', back_populates='user')  # One-to-Many avec Note

    # Méthodes
    def set_password(self, password):
        """Hash le mot de passe avant de le stocker."""
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        """Vérifie si le mot de passe correspond au hash stocké."""
        return check_password_hash(self.password_hash, password)

    def purchase_book(self, book):
        """Ajoute un livre à l'historique d'achat de l'utilisateur."""
        if self.purchase_history:
            history = self.purchase_history.split(',')
        else:
            history = []
        history.append(str(book.id))
        self.purchase_history = ','.join(history)

    def add_to_library(self, book):
        """Ajoute un livre à la bibliothèque de l'utilisateur."""
        if book not in self.library:
            self.library.append(book)
            db.session.commit()

    def update_profile(self, **kwargs):
        """Met à jour les champs du profil de l'utilisateur."""
        for key, value in kwargs.items():
            if hasattr(self, key):
                setattr(self, key, value)

    def reset_password(self, new_password):
        """Réinitialise le mot de passe de l'utilisateur."""
        self.set_password(new_password)

    def view_purchase_history(self):
        """Retourne la liste des livres achetés."""
        if self.purchase_history:
            book_ids = self.purchase_history.split(',')
            return [Book.query.get(book_id) for book_id in book_ids]
        return []
    
    @classmethod
    def get_by_username(cls, username):
        """Retourne l'utilisateur par son nom d'utilisateur."""
        return cls.query.filter_by(username = username).first()

    @classmethod
    def get_by_phone(cls, phone):
        """Retourne l'utilisateur par son nom d'utilisateur."""
        return cls.query.filter_by(phone = phone).first()

    def __repr__(self):
        return f'<User {self.username}>'


# Modèle Book
class Book(db.Model):
    __tablename__ = 'books'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String(255), nullable=False)
    author = db.Column(db.String(100), nullable=False)
    genre = db.Column(db.String(100), nullable=False)
    publication_date = db.Column(db.DateTime, default=datetime.now)
    ISBN = db.Column(db.String(20), unique=True, nullable=False)
    cover_image = db.Column(db.LargeBinary)  # L'image de couverture
    description = db.Column(db.String(1000))
    file_url = db.Column(db.String(255))  # URL pour télécharger le livre
    file = db.Column(db.LargeBinary)  # le livre
    price = db.Column(db.Float, nullable=False)
    nbr_page = db.Column(db.Integer)
    popularity = db.Column(db.Float)
    reading = db.Column(db.Boolean, default=False)  # Si le livre est en cours de lecture
    nbr_chapter = db.Column(db.Integer)  # Nombre de chapitres
    language = db.Column(db.String(50))
    publisher = db.Column(db.String(255))
    file_format = db.Column(db.String(50))  # Format du fichier (ePub, PDF, etc.)
    file_size = db.Column(db.Float)  # Taille du fichier
    tags = db.Column(db.String(255))  # Liste de tags
    store_id = db.Column(db.Integer, db.ForeignKey('stores.id'))  # Clé étrangère correctement définie
    library_id = db.Column(db.Integer, db.ForeignKey('libraries.id'))  # Clé étrangère correctement définie
    
    

    # Relations
    #reviews = db.relationship('Review', back_populates='book')  # Reviews sur le livre
    notes = db.relationship('Note', back_populates='book')  # Notes ajoutées par les utilisateurs
    bookmarks = db.relationship('Bookmark', back_populates='book')  # Marque-pages
    users = db.relationship('User', secondary=book_user, back_populates='library')  # Utilisateurs ayant ce livre
    categories = db.relationship('Category', secondary=book_category, back_populates='books')  # Catégories du livre
    # stores = db.relationship("Store", back_populates="available_books")
    library = db.relationship("Library", back_populates="books")

    # Méthodes
    def open(self):
        """Ouvrir le livre."""
        self.reading = True
        db.session.commit()

    def bookmarkPage(self, page_number):
        """Ajouter un marque-page à une page spécifique."""
        bookmark = Bookmark(page=page_number, book=self)
        db.session.add(bookmark)
        db.session.commit()

    def highlightText(self, text):
        """Surligner du texte spécifique."""
        highlight = Highlight(text=text, book=self)
        db.session.add(highlight)
        db.session.commit()

    def addNote(self, note_content):
        """Ajouter une note sur le livre."""
        note = Note(content=note_content, book=self)
        db.session.add(note)
        db.session.commit()

    def download(self):
        """Télécharger le livre."""
        # Implémentation pour télécharger le livre à partir de l'URL du fichier
        return self.file_url

    def share(self):
        """Partager le livre (générer un lien ou partager via une API)."""
        return f"Partager le livre: {self.title} - {self.file_url}"

    def rate(self, rating):
        """Noter le livre."""
        review = Review(rating=rating, book=self)
        db.session.add(review)
        db.session.commit()

    @classmethod
    def get_books_by_category(cls, category):
        """Retourne tous les livres d'une catégorie spécifique."""
        return cls.query.join(book_category).join(Category).filter(Category.name == category).all()

    def add_to_categories(self, category_ids):
        """Associe le livre à une ou plusieurs catégories."""
        categories = Category.query.filter(Category.id.in_(category_ids)).all()
        self.categories.extend(categories)
        db.session.commit()

    def __repr__(self):
        return f"<Book {self.title}>"


#--------------------------
# Category
#--------------------------
class Category(db.Model):
    __tablename__ = 'categories'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.String(1000))
    cover_image = db.Column(db.String(255))
    cover_image_data = db.Column(db.LargeBinary)  # Image stockée directement sous forme de BLOB
    popularity = db.Column(db.Float)

    # Relation avec Book (livres associés à cette catégorie)
    books = db.relationship('Book', secondary='book_category', back_populates='categories')

    def delete_category(category_id):
        """Supprimer une catégorie"""
        category = Category.query.get(category_id)
        if not category:
            return False  # La catégorie n'existe pas

        db.session.delete(category)
        db.session.commit()
        return True



    def addBook(self, book):
        """Ajouter un livre à cette catégorie"""
        if book not in self.books:
            self.books.append(book)

    def removeBook(self, book):
        """Supprimer un livre de cette catégorie"""
        if book in self.books:
            self.books.remove(book)

    def searchBook(self, search_term):
        """Rechercher un livre par son titre ou auteur dans cette catégorie"""
        return [book for book in self.books if search_term.lower() in book.title.lower() or search_term.lower() in book.author.lower()]
    
    def __repr__(self):
        return f'<Category {self.name}>'



# Modèle représentant une boutique de livres
# La classe Store permet de gérer les informations relatives à une boutique,
# y compris les livres disponibles, les promotions, les critiques des utilisateurs,
# les best-sellers et les nouvelles sorties.
class Store(db.Model):
    __tablename__ = 'stores'

    # Identifiant unique pour chaque store
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    
    # Relation un-à-plusieurs avec le modèle 'Book'. Un store peut avoir plusieurs livres disponibles.
    available_books = db.relationship('Book', backref='store', lazy=True)

    # Liste des promotions disponibles dans le store
    promotions = db.Column(db.String(1000))  # Chaîne de texte représentant des promotions

    # Liste des avis des utilisateurs concernant les livres du store
    user_reviews = db.Column(db.String(1000))  # Chaîne de texte représentant des critiques des utilisateurs

    # Liste des livres best-sellers du store
    best_sellers = db.Column(db.String(1000))  # Chaîne de texte représentant les best-sellers

    # Liste des nouvelles sorties du store
    new_releases = db.Column(db.String(1000))  # Chaîne de texte représentant les nouvelles sorties

    

    # Méthodes de la classe Store

    def searchBook(self, search_term):
        """Rechercher un livre disponible dans la boutique par titre ou auteur"""
        # Recherche des livres dont le titre ou l'auteur correspond à la recherche
        return [book for book in self.available_books if search_term.lower() in book.title.lower() or search_term.lower() in book.author.lower()]

    def purchaseBook(self, book):
        """Acheter un livre dans la boutique"""
        # Logique d'achat du livre, par exemple ajouter à l'historique d'achat de l'utilisateur ou réduire le stock
        if book in self.available_books:
            return f"Le livre '{book.title}' a été ajouté à votre panier."
        return "Ce livre n'est pas disponible dans la boutique."

    def browseCategories(self):
        """Parcourir les différentes catégories de livres proposées par la boutique"""
        # La logique pour parcourir les catégories peut varier en fonction de la structure des données
        # Exemple d'une liste fictive de catégories
        categories = ["Science Fiction", "Fantasy", "Romance", "Thriller", "Non-Fiction"]
        return categories

    def applyPromotion(self, promotion_code):
        """Appliquer une promotion à l'achat d'un livre"""
        # Logique pour appliquer une promotion en fonction d'un code, par exemple, offrir un pourcentage de réduction
        if promotion_code in self.promotions:
            return f"Promotion '{promotion_code}' appliquée avec succès."
        return "Code promotionnel invalide."

    def filterBooks(self, genre=None, price_range=None, popularity=None):
        """Filtrer les livres disponibles selon différents critères"""
        filtered_books = self.available_books

        # Filtrage par genre
        if genre:
            filtered_books = [book for book in filtered_books if book.genre.lower() == genre.lower()]

        # Filtrage par prix (ex: une gamme de prix entre 10 et 20)
        if price_range:
            min_price, max_price = price_range
            filtered_books = [book for book in filtered_books if min_price <= book.price <= max_price]

        # Filtrage par popularité (ex: livres avec une popularité supérieure à un certain seuil)
        if popularity:
            filtered_books = [book for book in filtered_books if book.popularity >= popularity]

        return filtered_books

    



# Modèle représentant une note ajoutée à un livre par un utilisateur
# La classe Note permet à un utilisateur de prendre des notes sur un livre spécifique.
class Note(db.Model):
    __tablename__ = 'notes'

    # Identifiant unique pour chaque note
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # Texte de la note
    text = db.Column(db.String(1000), nullable=False)

    # Numéro de la page sur laquelle la note a été ajoutée
    page_number = db.Column(db.Integer, nullable=False)

    # Date de création de la note
    date_created = db.Column(db.DateTime, default=datetime.now)

    # Référence au livre auquel la note appartient
    book_id = db.Column(db.Integer, db.ForeignKey('books.id'), nullable=False)

    # Référence à l'utilisateur qui a créé la note
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # Relations avec les autres modèles
    book = db.relationship('Book', back_populates='notes')
    user = db.relationship('User', back_populates='notes')

    # Méthodes de la classe Note

    def editNote(self, new_text):
        """Modifier le texte de la note"""
        self.text = new_text
        db.session.commit()

    def deleteNote(self):
        """Supprimer la note"""
        db.session.delete(self)
        db.session.commit()

    def shareNote(self):
        """Partager la note sous forme de texte"""
        return f"Note partagée: {self.text} (Livre: {self.book.title}, Page: {self.page_number})"



# Modèle représentant un marque-page ajouté par un utilisateur à un livre spécifique
# La classe Bookmark permet à un utilisateur de sauvegarder une page spécifique d'un livre en tant que marque-page.
class Bookmark(db.Model):
    __tablename__ = 'bookmarks'

    # Identifiant unique pour chaque marque-page
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # Numéro de la page où le marque-page a été ajouté
    page_number = db.Column(db.Integer, nullable=False)

    # Date de création du marque-page
    date_created = db.Column(db.DateTime, default=datetime.now)

    # Référence au livre auquel le marque-page appartient
    book_id = db.Column(db.Integer, db.ForeignKey('books.id'), nullable=False)

    # Référence à l'utilisateur qui a ajouté le marque-page
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # Relations avec les autres modèles
    book = db.relationship('Book', back_populates='bookmarks')
    user = db.relationship('User', back_populates='bookmarks')

    # Méthodes de la classe Bookmark

    def removeBookmark(self):
        """Supprimer le marque-page"""
        db.session.delete(self)
        db.session.commit()

    def shareBookmark(self):
        """Partager le marque-page sous forme de texte"""
        return f"Marque-page partagé: Livre - {self.book.title}, Page - {self.page_number}"



# Modèle représentant une bibliothèque d'utilisateur, qui contient une collection de livres et des informations associées.
# Chaque utilisateur peut avoir une bibliothèque personnalisée avec ses livres, catégories et un historique d'accès.
class Library(db.Model):
    __tablename__ = 'libraries'

    # Identifiant unique de la bibliothèque
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # Liste des livres dans la bibliothèque (relation avec le modèle Book)
    books = db.relationship('Book', back_populates='library')

    # Liste des catégories associées aux livres
    #categories = db.relationship('Category', secondary='book_category', back_populates='libraries')

    # Référence à l'utilisateur propriétaire de cette bibliothèque
    # user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # Date du dernier accès à la bibliothèque
    last_accessed = db.Column(db.DateTime, default=datetime.now)

    # Relation avec le modèle User pour l'utilisateur propriétaire
    # user = db.relationship('User', back_populates='library')

    # Méthodes de la classe Library

    def addBook(self, book):
        """Ajouter un livre à la bibliothèque"""
        if book not in self.books:
            self.books.append(book)
            db.session.commit()

    def removeBook(self, book):
        """Supprimer un livre de la bibliothèque"""
        if book in self.books:
            self.books.remove(book)
            db.session.commit()

    def organizeByCategory(self):
        """Organiser les livres par catégorie"""
        return sorted(self.books, key=lambda book: book.categories[0].name if book.categories else "")

    def searchBook(self, query):
        """Rechercher un livre par titre, auteur ou genre"""
        return [book for book in self.books if query.lower() in book.title.lower() or query.lower() in book.author.lower() or query.lower() in book.genre.lower()]

    def sortBooks(self, by='title'):
        """Trier les livres par un critère spécifié (par défaut par titre)"""
        if by == 'title':
            return sorted(self.books, key=lambda book: book.title.lower())
        elif by == 'author':
            return sorted(self.books, key=lambda book: book.author.lower())
        elif by == 'popularity':
            return sorted(self.books, key=lambda book: book.popularity, reverse=True)
        elif by == 'price':
            return sorted(self.books, key=lambda book: book.price)
        return self.books





class OtpVerification(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    phone = db.Column(db.String(15), nullable=False)
    otp_code = db.Column(db.String(6), nullable=False)
    expiry = db.Column(db.DateTime, nullable=False)

    def save(self, otpVerfication):
        """
        Sauvegarde un OTP dans la base de données.
        """
        db.session.add(otpVerfication)
        db.session.commit()

    def delete(self, otpVerfication):
        """
        Supprime un OTP de la base de données.
        """
        db.session.delete(otpVerfication)   
        db.session.commit()
