# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RegistrationHelper do
  
  context 'Registration' do
    it 'should succesfully register a user' do
      RegistrationHelper.register("newtestuser", "newtestuser", "asdasd@asd.asd", 22)

      LoginHelper.login("newtestuser", "newtestuser")

      expect(LoginHelper.get_logged_in_user.username).to eq("newtestuser")

      Loader.delete(:user, LoginHelper.get_logged_in_user)
    end

    it 'should fail to register with a username too short' do
      expect{RegistrationHelper.register("n", "newtestuser", "asdasd@asd.asd", 22)}.to raise_error "Username is too short"
    end

    it 'should fail to register with a password too short' do
      expect{RegistrationHelper.register("newtestuser", "a", "asdasd@asd.asd", 22)}.to raise_error "Password is too short"
    end

    it 'should fail to register if the email is wrongly formatted' do
      expect{RegistrationHelper.register("newtestuser", "newtestuser", "asd", 22)}.to raise_error "Email is not correctly formatted"
    end

    it 'should fail if age is too low' do
      expect{RegistrationHelper.register("newtestuser", "newtestuser", "asdasd@asd.asd", -10)}.to raise_error "Age must be between 1 and 100"
    end

    it 'should fail if age is too large' do
      expect{RegistrationHelper.register("newtestuser", "newtestuser", "asdasd@asd.asd", 150)}.to raise_error "Age must be between 1 and 100"
    end
  end

end