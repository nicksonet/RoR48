# frozen_string_literal: true

require_relative 'company'
require_relative 'validation'
require_relative 'accessors'

class PassengerCarriage
  include Company
  include Validation
  include Accessors

  attr_reader :occupied_seats_count
  attr_accessor :total_seats

  validate :total_seats, :presence
  validate :total_seats, :type, Integer

  def initialize(company_name, total_seats)
    @total_seats = total_seats
    @occupied_seats_count = 0
    self.company_name = company_name
    validate!
  end

  def take_seat
    raise 'No available seats' if occupied_seats_count >= total_seats

    @occupied_seats_count += 1
  end

  def free_seats_count
    total_seats - occupied_seats_count
  end
end
