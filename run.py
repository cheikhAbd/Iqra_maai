from app import create_app
from app.routes import routes
from app.auth import auth_bp
from app.books import book_bp


app = create_app()
app.register_blueprint(routes)
app.register_blueprint(auth_bp,url_prefix= '/auth')
app.register_blueprint(book_bp)


if __name__ == '__main__':
    app.run(host='192.168.100.5', debug=True,)