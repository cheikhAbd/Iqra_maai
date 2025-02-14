class Config:
    SQLALCHEMY_DATABASE_URI = "postgresql://cheikh:1234@localhost:5432/iqra_maai"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    JWT_SECRET_KEY = '082db220eb5d26e2d7a795d7ad61f6bf'
    JWT_ACCESS_TOKEN_EXPIRES = 86400  # 20 minutes pour l'access token
    JWT_REFRESH_TOKEN_EXPIRES = 86400  # 1 jour pour le refresh token

    #----------------------
    # ChinguiSoft 
    #----------------------
    # Your unique validation key provided by Chinguisoft.
    validation_key = 'sou1exrIoaUFVxlC'
    # The API token required for authorization.
    token = 'X32HQ38ERgP5GIAA1pjlu8nuZbH41mrE'