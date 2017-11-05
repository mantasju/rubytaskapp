# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LoginHelper do

  context 'login' do
    it 'should not allow empty username' do
      expect{LoginHelper.login("", "a")}.to raise_error("Username cannot be blank")
    end

    it 'should not allow empty password' do
      expect{LoginHelper.login("a", "")}.to raise_error("Password cannot be blank")
    end

    it 'should not allow to login with incorrect password' do
      expect{LoginHelper.login("testuser", "a")}.to raise_error("Password is incorrect")
    end

    it 'should not allow to login with incorrect username' do
      expect{LoginHelper.login("sdjfhbdsvjsdhviuvhnehvbvjhrbvuireniobrebnreuibrebhjerkisduvhjsdbiusdvybsuvbjhsdvtestuser", "testuser")}.to raise_error("Username is incorrect")
    end

    it 'should successfully login' do
      LoginHelper.login("testuser", "testuser")
      expect(LoginHelper.is_logged_in?).to be true
    end

    it 'should return successfully logout' do
      LoginHelper.login("testuser", "testuser")
      LoginHelper.logout
      expect(LoginHelper.is_logged_in?).to be false
    end

    it 'should fail to get logged in user if not logged in' do
      expect{LoginHelper.get_logged_in_user}.to raise_error("You are not logged in")
    end
  end

end