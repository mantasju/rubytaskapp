# frozen_string_literal: true

# Defines test item used in Loader tests
class TestItem
  attr_reader :test_string, :random_value

  def initialize(string)
    @test_string = string
    @random_value = 0
  end

  def change_random_value(value)
    @random_value = value
  end

  def ==(other)
    test_string == other.test_string
  end
end
