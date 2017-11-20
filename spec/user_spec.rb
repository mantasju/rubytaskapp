# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User do
  context 'initialize' do
    it 'should not allow creation with a bad email' do
      expect { User.new('asdasd', 'asdasd', 13, 15) }
        .to raise_error 'Email must be a string'
    end

    it 'should not allow creation with a bad age' do
      expect { User.new('asdasd', 'asdasd', 'a@a.a', 'asd') }
        .to raise_error 'Age must be a number'
    end

    it 'should have the correct age after creation' do
      expect(User.new('asdasd', 'asdasd', 'a@a.a', 15).age).to eq 15
    end

    it 'should have the correct email after creation' do
      expect(User.new('asdasd', 'asdasd', 'a@a.a', 15).email).to eq 'a@a.a'
    end

    it 'should encrypt the password during creation' do
      expect(User.new('asdasd', 'asdasd', 'a@a.a', 15).password)
        .to eq Digest::MD5.hexdigest('asdasd')
    end
  end

  context 'equal' do
    it 'two users should eq if their usernames are eq' do
      expect(User.new('asdasdasd', 'asdasdasd', 'a@a.a', 15))
        .to eq(User.new('asdasdasd', 'a', 'b@b.b', 14))
    end

    it 'two users shouldnt eq if their usernames are not eq' do
      expect(User.new('asdasdasd', 'asdasdasd', 'a@a.a', 15))
        .not_to eq(User.new('asdsdfasdasd', 'a', 'b@b.b', 14))
    end
  end
end
