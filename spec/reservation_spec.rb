# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Reservation do
  context 'equals' do

    it 'should be equal with same start time and length' do
      time = Time.new

      r1 = Reservation.new(time, time + 1 * 60 * 60)
      r2 = Reservation.new(time, time + 1 * 60 * 60)

      expect(r1).to eq r2
    end

    it 'should not equal if times are equal but lengths are different' do
      time = Time.new

      r1 = Reservation.new(time, time + 1 * 60 * 60)
      r2 = Reservation.new(time, time + 2 * 60 * 60)

      expect(r1).not_to eq r2
    end

    it 'should not equal if times are not equal but lengths are equal' do
      time = Time.new

      r1 = Reservation.new(time, time + 2 * 60 * 60)
      r2 = Reservation.new(time + 1 * 60, time + 2 * 60 * 60)

      expect(r1).not_to eq r2
    end
  end
end