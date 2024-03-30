app_user_email = ENV.fetch("APP_USER_EMAIL", "foo@email.com")
app_user_password = ENV.fetch("APP_USER_PASSWORD", "12345678")
user = User.where(email: app_user_email).first_or_initialize
user.update!(password: app_user_password, password_confirmation: app_user_password)
