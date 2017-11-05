# frozen_string_literal: true

class Review
  attr_reader :text, :time, :user

  def initialize(time, text, user)
    @time, @text, @user = time, text, user
  end
end