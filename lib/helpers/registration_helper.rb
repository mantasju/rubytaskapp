# frozen_string_literal: true

class RegistrationHelper
  def self.register(username, password, email, age)
    raise "Username is too short" if username.length < 3
    raise "Password is too short" if password.length < 5
    raise "Email is not correctly formatted" if !correct_email?(email)
    raise "Age must be between 1 and 100" if !age.between?(0,100)

    new_user = User.new(username, password, email, age)

    Loader.insert(:user, new_user)
  end

  private
  def self.correct_email?(email)
    email.match? "\\w+@\\w+[.]\\w+"
  end
end