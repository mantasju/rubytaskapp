# frozen_string_literal: true

require_relative 'database/loader'
#require_relative 'helpers/login_helper'
#require_relative 'helpers/registration_helper'
require_relative 'user'
#require_relative 'court'
require_relative 'test_item'
require_relative 'court'
require 'time'

Loader.insert(:user, User.new("testuser", "testuser", "test@test.test", 10))

#LoginHelper.login("asdasd", "password")
#puts LoginHelper.is_logged_in?

#court = Loader.get(:court, {"x" => 1, "y" => 1})
#court.create_review("shitwtf")

#LoginHelper.login("cabc", "asd")
#court = Court.new(1,1,"Vilnius")
#puts court.inspect

#puts LoginHelper.login("abc", "def")
#puts LoginHelper.get_logged_in_user
#puts LoginHelper.logout

#Loader.insert(:user, User.new("abc", "def", "asasd@asasdd.com", 25))
#a = Loader.get_all(:user)
#Loader.update(:user, a[0])
#Loader.delete(:user, a[0])
#a = Loader.get_all(:test)
#a.each {|item| puts item.inspect}