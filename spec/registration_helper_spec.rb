# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RegistrationHelper do
  context 'Registration' do
    it 'should succesfully register a user' do
      user = Loader.get(:user, 'username' => 'newtestuser')

      Loader.delete(:user, user) unless user.nil?

      user = User.new('newtestuser', 'newtestuser', 'asdasd@asd.asd', 22)
      RegistrationHelper.register(user)

      LoginHelper.login('newtestuser', 'newtestuser')

      expect(LoginHelper.logged_in_user.username).to eq('newtestuser')

      Loader.delete(:user, LoginHelper.logged_in_user)
    end

    it 'should fail to register if the email is wrongly formatted' do
      user = User.new('newtestuser', 'newtestuser', 'asd', 22)
      expect { RegistrationHelper.register(user) }
        .to raise_error 'Email is not correctly formatted'
    end
  end
end
