# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Court do

  RSpec::Matchers.define :contain_review_text do |expected|
    match do |actual|
      actual.each do |review|
        return true if review.text.eql? expected
      end
      return false
    end
  end

  RSpec::Matchers.define :contain_reservation_time do |expected|
    match do |actual|
      actual.each do |reservation|
        return true if reservation.start_time.eql? expected
      end
      return false
    end
  end

  before(:all) do
    LoginHelper.login("testuser", "testuser")
    @court = Court.new(1000, 1000, "Viluva")
    Loader.insert(:court, @court)
    @court.add_reservation(Time.new - 5 * 60 * 60, 1)
  end

  after(:all) do
    Loader.delete(:court, @court)
    LoginHelper.logout
  end
  
  context 'equals' do
    it 'should fail if only x\'es are equal' do
      court1 = Court.new(1, 1, "a")
      court2 = Court.new(1, 2, "a")

      expect(court1 == court2).to be false
    end

    it 'should fail if only y\'es are equal' do
      court1 = Court.new(1, 1, "a")
      court2 = Court.new(2, 1, "a")

      expect(court1 == court2).to be false
    end

    it 'should succeed if x and y are both equal' do
      court1 = Court.new(1, 1, "a")
      court2 = Court.new(1, 1, "a")

      expect(court1 == court2).to be true
    end
  end

  context 'review' do
    it 'should succesfully create a review' do
      text = "This is a test review"
      @court.create_review(text)

      expect(@court.reviews).to contain_review_text(text)
    end
  end

  context 'reservations' do
    it 'should succesfully create a reservation' do
      time = Time.new

      @court.add_reservation(time, 1)

      expect(@court.reservations).to contain_reservation_time(time)

      @court.remove_reservation(time)
    end

    it 'should not allow to create a reservation when one is already created on a date (by start time)' do
      time = Time.new

      @court.add_reservation(time, 1)

      expect{@court.add_reservation(time + 30 * 60, 1)}.to raise_error "Reservation time is already taken"

      @court.remove_reservation(time)
    end

    it 'should not allow to create a reservation when one is already created on a date (by end time)' do
      time = Time.new

      @court.add_reservation(time, 1)

      expect{@court.add_reservation(time - 30 * 60, 1)}.to raise_error "Reservation time is already taken"

      @court.remove_reservation(time)
    end

    it 'should succesfully remove a reservation' do
      time = Time.new + 24 * 60 * 60

      @court.add_reservation(time, 1)

      @court.remove_reservation(time)

      expect(@court.reservations).to_not contain_reservation_time(time)
    end
  end

end