# frozen_string_literal: true

require_relative 'carriage'
require_relative 'validation'

class PassengerCarriage < Carriage
  include Validation

  COMPANY_NAME_FORMAT = /\A[a-zA-Z\s&'-]{1,30}\z/

  attr_reader :total_seats, :occupied_seats

  validate :company_name, :presence
  validate :company_name, :format, with: COMPANY_NAME_FORMAT

  def initialize(company_name, total_seats)
    super()
    @company_name = company_name
    @total_seats = total_seats
    @occupied_seats = 0
    validate!
  end

  def take_seat
    raise 'Нет свободных мест' if full?

    @occupied_seats += 1
    @occupied_seats
  end

  def occupied_seats_count
    @occupied_seats
  end

  def free_seats_count
    @total_seats - @occupied_seats
  end

  private

  def full?
    @occupied_seats == @total_seats
  end
end
