# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Loader do
  # Pass old value as first and updated value as 2nd argument
  RSpec::Matchers.define :be_succesfully_updated_to do |expected|
    match do |actual|
      item = Loader.get(:test, 'test_string' => actual.test_string)
      return false if item.random_value == actual.random_value
      return false if item.random_value != expected.random_value

      true
    end
  end

  before(:each) do
    File.open(Loader.get_file_name_by_symbol(:test), 'w') do |a|
    end
    @test_item = TestItem.new('hello')
  end

  after(:each) do
    unless Loader.get(:test, 'test_string' => 'hello').nil?
      Loader.delete(:test, @test_item)
    end
  end

  context 'general' do
    it 'should not allow to use a random symbol' do
      expect { Loader.insert(:randomlalala, @test_item) }
        .to raise_error(KeyError)
    end
  end

  context 'insert' do
    it 'should successfully insert an item' do
      Loader.insert(:test, @test_item)
      expect(Loader.get(:test, 'test_string' => 'hello')).not_to be_nil
    end

    it 'should not allow to add a non-unique item' do
      Loader.insert(:test, @test_item)
      expect { Loader.insert(:test, @test_item) }
        .to raise_error('Given item is not unique')
    end

    it 'should not allow to add a wrong item type' do
      expect { Loader.insert(:user, @test_item) }
        .to raise_error('Incorrect item type provided')
    end
  end

  context 'update' do
    it 'should successfully update an item' do
      Loader.insert(:test, @test_item)
      @test_item.change_random_value(1)
      Loader.update(:test, @test_item)
      expect(TestItem.new('hello')).to be_succesfully_updated_to(@test_item)
    end

    it 'should fail if given an incorrect type item' do
      expect { Loader.update(:team, @test_item) }
        .to raise_error 'Incorrect item type provided'
    end

    it 'should only update a single item' do
      Loader.insert(:test, @test_item)
      other_test_item = TestItem.new('holahola')
      Loader.insert(:test, other_test_item)
      @test_item.change_random_value(1)
      Loader.update(:test, @test_item)

      expect(TestItem.new('hello')).to be_succesfully_updated_to(@test_item)
      expect(Loader.get(:test, 'test_string' => 'holahola')).not_to be_nil

      Loader.delete(:test, other_test_item)
    end
  end

  context 'get all' do
    it 'should return all test items' do
      Loader.insert(:test, @test_item)
      expect(Loader.get_all(:test).length).to eq(1)
    end
  end

  context 'get' do
    it 'should succesfully get an item' do
      Loader.insert(:test, @test_item)
      expect(Loader.get(:test, 'test_string' => 'hello')).not_to be_nil
    end

    it 'should return nil if no item is found' do
      expect(Loader.get(:test, 'test_string' => 'hello')).to be_nil
    end
  end

  context 'delete' do
    it 'should succesfully delete an item' do
      test_item = TestItem.new('hello_delete_test')
      Loader.insert(:test, test_item)
      Loader.delete(:test, test_item)
      expect(Loader.get(:test, 'test_string' => 'hello_delete_test')).to be_nil
    end

    it 'should only delete a single item' do
      other_test_item = TestItem.new('another_hello_delete_test')
      Loader.insert(:test, other_test_item)
      Loader.insert(:test, @test_item)
      Loader.delete(:test, @test_item)
      item = Loader.get(:test, 'test_string' => 'another_hello_delete_test')
      expect(item.test_string)
        .to eq 'another_hello_delete_test'
      Loader.delete(:test, other_test_item)
    end

    it 'should fail with an incorrect type item' do
      test_item = TestItem.new('hello_delete_test')
      Loader.insert(:test, test_item)
      expect { Loader.delete(:user, test_item) }
        .to raise_error 'Incorrect item type provided'
      Loader.delete(:test, test_item)
    end
  end
end
