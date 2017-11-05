# frozen_string_literal: true

require 'yaml'
require 'digest/md5'

# The User class is responsible for defining a User in the app
class User
  attr_reader :username, :email, :age, :password, :favourite_courts
  attr_writer :email, :age

  def initialize(username, password, email, age)
    @username = username
    @password = Digest::MD5.hexdigest(password)
    @email = email
    @age = age
    @favourite_courts = []
  end

  def ==(o)
    username == o.username
  end

  def add_favourite_court(court)
    raise "Given object is not a court" if !court.is_a? Court

    favourite_courts.push(court)
    Loader.update(:user, self)
  end

  def remove_favourite_court(court)
    raise "Given object is not a court" if !court.is_a? Court

    favourite_courts.delete(court)
    Loader.update(:user, self)
  end
end