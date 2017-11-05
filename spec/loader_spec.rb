# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Loader do

  before(:each) do
    @test_item = TestItem.new("hello")
  end

  after(:each) do
    Loader.delete(:test, @test_item) if !Loader.get(:test, {"test_string" => "hello"}).nil?
  end

  context 'general' do
    it 'should not allow to use a random symbol' do
      expect{Loader.insert(:randomlalala, @test_item)}.to raise_error("Incorrect symbol provided")
    end
  end

  context 'insert' do
    it 'should successfully insert an item' do
      Loader.insert(:test, @test_item)
      expect(Loader.get(:test, {"test_string" => "hello"})).not_to be_nil
    end

    it 'should not allow to add a non-unique item' do
      Loader.insert(:test, @test_item)
      expect{Loader.insert(:test, @test_item)}.to raise_error("Given item is not unique")
    end

    it 'should not allow to insert a nil value' do
      expect{Loader.insert(:test, nil)}.to raise_error("Can't perform operations with a nil value")
    end
  end

  context 'update' do
    it 'should successfully update an item' do
      Loader.insert(:test, @test_item)
      @test_item.random_value = 1
      Loader.update(:test, @test_item)
      expect(Loader.get(:test, {"test_string" => "hello"}).random_value).to eq 1
    end
  end

  context 'get' do
    it 'should succesfully get an item' do
      Loader.insert(:test, @test_item)
      expect(Loader.get(:test, {"test_string" => "hello"})).not_to be_nil
    end
  end

  context 'delete' do
    it 'should succesfully delete an item' do
      test_item = TestItem.new("hello_delete_test")
      Loader.insert(:test, test_item)
      Loader.delete(:test, test_item)
      expect(Loader.get(:test, {"test_string" => "hello_delete_test"})).to be_nil
    end
  end
end