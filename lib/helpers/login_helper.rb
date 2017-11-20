# frozen_string_literal: true

require 'digest/md5'

# Helps with logging in and checking the logged in state
class LoginHelper
  def self.login(username, password)
    raise 'Fields cannot be blank' if username.empty? || password.empty?

    user = Loader.get(:user, 'username' => username)

    raise 'Username is incorrect' unless user
    unless Digest::MD5.hexdigest(password).eql? user.password
      raise 'Password is incorrect'
    end
    @logged_in_user = user
  end

  def self.logout
    @logged_in_user = nil
  end

  def self.logged_in?
    @logged_in_user.instance_of? User
  end

  def self.logged_in_user
    raise 'You are not logged in' unless logged_in?

    @logged_in_user
  end
end
