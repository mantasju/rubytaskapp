# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User do
  
  before(:all) do
    LoginHelper.login("testuser", "testuser")
    @user = LoginHelper.get_logged_in_user
  end

  after(:all) do
    LoginHelper.logout
  end

  context 'courts' do
    it 'should succesfully add a new favourite court' do
      court = Court.new(1000, 1000, "asdasd")
      
      @user.add_favourite_court(court)

      expect(@user.favourite_courts).to include(court)
      @user.remove_favourite_court(court)
    end

    it 'should succesfully remove a favourite court' do
      court = Court.new(1000, 1000, "asdasd")


      @user.add_favourite_court(court)
      @user.remove_favourite_court(court)

      expect(@user.favourite_courts).not_to include(court)
    end
  end
end