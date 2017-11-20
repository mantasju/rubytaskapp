# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Court do
  # You have to pass start time as first argument and length as second
  RSpec::Matchers.define :contain_reservation_time do |*expected|
    match do |actual|
      actual.each do |res|
        start = expected[0]
        end_time = expected[0] + expected[1] * 60 * 60
        return true if (res.start_time == start) && (res.end_time == end_time)
      end
      return false
    end
  end

  before(:all) do
    LoginHelper.login('testuser', 'testuser')
    @court = Court.new(1000, 1000)
    @court.add_reservation(Time.new - 5 * 60 * 60, 1)
  end

  after(:all) do
    LoginHelper.logout
  end

  context 'creation' do
    it 'should have the creating user as the creator after creation' do
      expect(@court.created_by).to eq(LoginHelper.logged_in_user)
    end
  end

  context 'equals' do
    it 'should fail if only x\'es are equal' do
      court1 = Court.new(1, 1)
      court2 = Court.new(1, 2)

      expect(court1 == court2).to be false
    end

    it 'should fail if only y\'es are equal' do
      court1 = Court.new(1, 1)
      court2 = Court.new(2, 1)

      expect(court1 == court2).to be false
    end

    it 'should succeed if x and y are both equal' do
      court1 = Court.new(1, 1)
      court2 = Court.new(1, 1)

      expect(court1 == court2).to be true
    end
  end

  context 'reservations' do
    it 'should succesfully create a reservation' do
      time = Time.new

      @court.add_reservation(time, 1)

      expect(@court.reservations)
        .to contain_reservation_time(time, 1)

      @court.remove_reservation(time)
    end

    it 'should succesfully remove a reservation' do
      time = Time.new + 24 * 60 * 60

      @court.add_reservation(time, 1)

      @court.remove_reservation(time)

      expect(@court.reservations)
        .to_not contain_reservation_time(time, 1)
    end
  end
end
