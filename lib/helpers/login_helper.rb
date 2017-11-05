# frozen_string_literal: true

require 'digest/md5'

class LoginHelper

  #returns logged in user if login is successful
  def self.login(username, password)
    raise "Username cannot be blank" if username.to_s.empty?
    raise "Password cannot be blank" if password.to_s.empty?

    user = Loader.get(:user, {"username" => username})

    raise "Username is incorrect" if user.nil?
    raise "Password is incorrect" if Digest::MD5.hexdigest(password) != user.password
    
    @logged_in_user = user
  end

  def self.logout
    @logged_in_user = nil
  end

  def self.is_logged_in?
    !@logged_in_user.nil?
  end

  def self.get_logged_in_user
    raise "You are not logged in" if !is_logged_in?

    @logged_in_user
  end
end