# frozen_string_literal: true

require_relative 'reservation'
require_relative './helpers/login_helper'
# Defines Court object
class Court
  attr_reader :longitude, :latidute, :created_by, :reservations

  def initialize(longitude, latidute)
    @longitude = longitude
    @latidute = latidute
    @created_by = LoginHelper.logged_in_user
    @reservations = []
  end

  def add_reservation(start_time, length)
    reservations.push(Reservation.new(start_time, length))
  end

  def remove_reservation(start_time)
    reservations.each do |reservation|
      if reservation.start_time.equal? start_time
        reservations.delete(reservation)
      end
    end
  end

  def ==(other)
    longitude.eql?(other.longitude) && latidute.eql?(other.latidute)
  end
end
