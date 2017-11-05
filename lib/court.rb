# frozen_string_literal: true

require_relative 'review'
require_relative 'reservation'
require_relative './helpers/login_helper'
class Court

  attr_reader :x, :y, :city, :created_by, :reservations, :reviews

  def initialize(x, y, city)
    @x = x
    @y = y
    @city = city
    @created_by = LoginHelper.get_logged_in_user
    @reservations = []
    @reviews = []
  end

  def create_review(text)
    reviews.push(Review.new(Time.new, text, LoginHelper.get_logged_in_user))
    Loader.update(:court, self)
  end

  def add_reservation(start_time, length)
    reservations.each do |reservation|
      raise "Reservation time is already taken" if start_time.between?(reservation.start_time, reservation.end_time)
      raise "Reservation time is already taken" if (start_time + (length * 60 * 60)).between?(reservation.start_time, reservation.end_time)
    end

    @reservations.push(Reservation.new(start_time, start_time + (length * 60 * 60)))
    Loader.update(:court, self)
  end

  def remove_reservation(start_time)

    reservation_count = reservations.length

    reservations.each do |reservation|
      reservations.delete(reservation) if reservation.start_time.eql? start_time
    end

    Loader.update(:court, self) if reservation_count != reservations.length
  end

  def ==(o)
    x.equal?(o.x) && y.equal?(o.y)
  end
end
