# frozen_string_literal: true

# Defines Reservation class used for Courts
class Reservation
  attr_reader :start_time, :end_time

  def initialize(start_time, length)
    unless start_time.instance_of? Time
      raise 'Reservation start time must be a time'
    end

    @start_time = start_time
    @end_time = start_time + length * 60 * 60
  end

  def ==(other)
    (start_time.eql?(other.start_time) &&
     end_time.eql?(other.end_time))
  end
end
