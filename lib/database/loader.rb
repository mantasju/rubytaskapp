# frozen_string_literal: true

require 'yaml'
require_relative '../user'
require_relative '../team'
require_relative '../court'
require_relative '../test_item'

class Loader

  @@type_mapping = {
    :user => User,
    :court => Court,
    :team => Team,
    :test => TestItem
  }

	@@mapping = {
		:user => "users.yml",
    :court => "courts.yml",
    :team => "teams.yml",
    :test => "test.yml"
	}

  @@unique_constraints = {
    :user => ["username"],
    :court => ["x", "y"],
    :team => ["team_owner", "team_name"],
    :test => ["test_string"]
  }

  def self.insert(symbol, item_to_insert)
    file_name = get_file_name_by_symbol(symbol)
    ensure_correct(symbol, item_to_insert)
    ensure_unique(symbol, item_to_insert)

    File.open(file_name, 'a') do |output|
      output.puts(YAML.dump(item_to_insert))
    end
  end

  def self.update(symbol, item_to_update)
    file_name = get_file_name_by_symbol(symbol)
    ensure_correct(symbol, item_to_update)

    all_items = get_all(symbol)

    real_item = get(symbol,generate_hash_keys(symbol, item_to_update))

    raise "No item found to update" if real_item.nil?

    all_items.delete(real_item)
    all_items.push(item_to_update)

    File.open(file_name, 'w') do |output|
      all_items.each{|item| output.puts(YAML.dump(item))}
    end
  end

  def self.get(symbol, keys_to_read)
    arr = get_all(symbol)
    arr.find do |item| 
      match_count = 0
      @@unique_constraints.fetch(symbol).each do |key| match_count += 1 if item.public_send(key).eql? keys_to_read.fetch(key) end
      match_count.equal? @@unique_constraints.fetch(symbol).length
    end
  end

  def self.get_all(symbol)
    File.open(get_file_name_by_symbol(symbol)) do |input|
      YAML.load_stream(input)
    end
  end

  def self.delete(symbol, item_to_delete)
    file_name = get_file_name_by_symbol(symbol)
    ensure_correct(symbol, item_to_delete)

    all_items = get_all(symbol)

    real_item_to_delete = get(symbol, generate_hash_keys(symbol, item_to_delete))

    all_items = all_items.select{|item| item != real_item_to_delete }

    File.open(file_name, 'w') do |output|
      all_items.each{|item| output.puts(YAML.dump(item))}
    end
  end

	def self.get_file_name_by_symbol(symbol)
      @@mapping.fetch(symbol)
	end

  def self.ensure_unique(symbol, item_to_ensure)

    read_items = get_all(symbol)

    read_items.each do |item|
      match_count = 0
      @@unique_constraints.fetch(symbol).each do |constraint|
        match_count += 1 if item_to_ensure.public_send(constraint).eql? item.public_send(constraint) 
      end
      raise "Given item is not unique" if match_count.equal? @@unique_constraints.fetch(symbol).length
    end
  end

  def self.ensure_correct(symbol, item_to_ensure)
    raise "Can't perform operations with a nil value" if item_to_ensure.nil?

    raise "Incorrect item type provided" if !@@type_mapping.fetch(symbol).equal? item_to_ensure.class
  end

  private
  def self.generate_hash_keys(symbol, item_to_generate_from)
    key_hash = {}
    @@unique_constraints.fetch(symbol).each do |key| 
      key_hash[key] = item_to_generate_from.public_send(key)
     end
    key_hash
  end
end