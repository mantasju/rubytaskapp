# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Reservation do
  context 'creation' do
    it 'should fail if reservation time is nil' do
      user = User.new('aaaaaaa', 'aaaaaaa', 'a@a.a', 5)
      expect { Reservation.new(user, 1) }
        .to raise_error 'Reservation start time must be a time'
    end

    it 'should have the correct end time upon creation' do
      time = Time.new

      reservation = Reservation.new(time, 1)

      expect(reservation.end_time).to eq(time + 1 * 60 * 60)
    end
  end

  context 'equals' do
    it 'should be equal with same start time and length' do
      r1 = Reservation.new(Time.new(2002), 1)
      r2 = Reservation.new(Time.new(2002), 1)

      expect(r1).to eq r2
    end

    it 'should not equal if times are equal but lengths are different' do
      time = Time.new

      r1 = Reservation.new(time, 1)
      r2 = Reservation.new(time, 2)

      expect(r1).not_to eq r2
    end

    it 'should not equal if times are not equal but lengths are equal' do
      time = Time.new

      r1 = Reservation.new(time, 2)
      r2 = Reservation.new(time + 1 * 60, 2)

      expect(r1).not_to eq r2
    end

    it 'should not equal if start times are different but end times are same' do
      time = Time.new

      r1 = Reservation.new(time, 2)
      r2 = Reservation.new(time + 1 * 60 * 60, 1)

      expect(r1).not_to eq r2
    end

    it 'should not equal if both times and lengths are different' do
      time = Time.new

      r1 = Reservation.new(time, 9)
      r2 = Reservation.new(time + 1 * 60, 2)

      expect(r1).not_to eq r2
    end
  end
end
