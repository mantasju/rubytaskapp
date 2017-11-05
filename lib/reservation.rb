# frozen_string_literal: true

class Reservation

  attr_reader :start_time, :end_time

  def initialize(start_time, end_time)
    @start_time, @end_time = start_time, end_time
  end

  def ==(o)
    (start_time.to_s.eql?(o.start_time.to_s) && end_time.to_s.eql?(o.end_time.to_s))
  end
end