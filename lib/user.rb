# frozen_string_literal: true

require 'yaml'
require 'digest/md5'
require_relative 'court'

# The User class is responsible for defining a User in the app
class User
  attr_reader :username, :email, :age, :password

  def initialize(username, password, email, age)
    raise 'Age must be a number' unless age.is_a? Numeric
    raise 'Email must be a string' unless email.instance_of? String

    @username = username
    @password = Digest::MD5.hexdigest(password)
    @email = email
    @age = age
  end

  def ==(other)
    username.equal? other.username
  end
end
