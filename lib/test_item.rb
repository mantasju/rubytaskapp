class TestItem

  attr_accessor :test_string, :random_value

  def initialize(string)
    @test_string = string
    @random_value = 0
  end

  def ==(o)
    test_string == o.test_string
  end
end