# frozen_string_literal: true

require_relative 'company'
require_relative 'validation'
require_relative 'accessors'

class CargoCarriage
  include Company
  include Validation
  include Accessors

  attr_reader :occupied_volume
  attr_accessor :total_volume

  validate :total_volume, :presence
  validate :total_volume, :type, Float

  def initialize(company_name, total_volume)
    @total_volume = total_volume
    @occupied_volume = 0
    self.company_name = company_name
    validate!
  end

  def occupy_volume(volume)
    raise "Not enough space. Available: #{available_volume}" if volume > available_volume

    @occupied_volume += volume
  end

  def available_volume
    @total_volume - @occupied_volume
  end
end
