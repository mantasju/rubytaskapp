# frozen_string_literal: true

require 'yaml'
require_relative '../user'
require_relative '../team'
require_relative '../court'
require_relative '../test_item'

# Helps with work with files
class Loader
  def self.insert(symbol, item_to_insert)
    file_name = get_file_name_by_symbol(symbol)
    ensure_correct(symbol, item_to_insert)
    ensure_unique(symbol, item_to_insert)

    append_to_file(file_name, item_to_insert)
  end

  def self.update(sym, item)
    ensure_correct(sym, item)

    all_items = get_all(sym).reject do |it|
      item == get(sym, hash_keys(sym, it))
    end
    all_items.push(item)

    write_to_file(get_file_name_by_symbol(sym), all_items)
  end

  def self.get(symbol, keys_to_read)
    constraints = @unique_constraints.fetch(symbol)
    get_all(symbol).find do |item|
      compare_by_constraints(constraints, item, keys_to_read)
    end
  end

  def self.get_all(symbol)
    File.open(get_file_name_by_symbol(symbol)) do |input|
      YAML.load_stream(input)
    end
  end

  def self.delete(symbol, item_to_delete)
    ensure_correct(symbol, item_to_delete)

    real_item_to_delete = get(symbol, hash_keys(symbol, item_to_delete))
    all_items = get_all(symbol).reject { |item| item == real_item_to_delete }

    write_to_file(get_file_name_by_symbol(symbol), all_items)
  end

  def self.get_file_name_by_symbol(symbol)
    @mapping.fetch(symbol)
  end

  def self.ensure_unique(symbol, item_to_ensure)
    read_items = get_all(symbol)

    read_items.each do |item|
      raise 'Given item is not unique' if items_equal?(item, item_to_ensure)
    end
  end

  def self.ensure_correct(symbol, item)
    cla = item.class
    raise 'Incorrect item type provided' unless symbols_equal(symbol, cla)
  end

  def self.symbols_equal(first_sym, second_sym)
    @type_mapping.fetch(first_sym).equal? second_sym
  end

  def self.compare_by_constraints(constraints, item, keys_to_read)
    match_count = 0
    constraints.each do |key|
      match_count += 1 if item.public_send(key).eql? keys_to_read.fetch(key)
    end
    match_count.equal? constraints.length
  end

  def self.items_equal?(first_item, second_item)
    first_item == second_item
  end

  def self.append_to_file(file_name, item)
    File.open(file_name, 'a') do |output|
      output.puts(YAML.dump(item))
    end
  end

  def self.write_to_file(file_name, items)
    file = File.new(file_name, 'w')
    items.each { |item| file.puts(YAML.dump(item)) }
    file.close
  end

  def self.hash_keys(symbol, item_to_generate_from)
    key_hash = {}
    @unique_constraints.fetch(symbol).each do |key|
      key_hash[key] = item_to_generate_from.public_send(key)
    end
    key_hash
  end

  @type_mapping = {
    user: User,
    court: Court,
    team: Team,
    test: TestItem
  }

  @mapping = {
    user: 'users.yml',
    court: 'courts.yml',
    team: 'teams.yml',
    test: 'test.yml'
  }

  @unique_constraints = {
    user: %w[username],
    court: %w[longitude latidute],
    team: %w[team_owner team_name],
    test: %w[test_string]
  }
end
