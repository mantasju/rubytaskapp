# frozen_string_literal: true

# Helps with user registration
class RegistrationHelper
  def self.register(user)
    raise 'Email is not correctly formatted' unless correct_email?(user.email)

    Loader.insert(:user, user)
  end

  private_class_method def self.correct_email?(email)
    email.match? '\\w+@\\w+[.]\\w+'
  end
end
