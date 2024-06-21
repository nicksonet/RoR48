require_relative 'carriage'
require_relative 'validation'

class CargoCarriage < Carriage
  include Validation

  COMPANY_NAME_FORMAT = /\A[a-zA-Z\s&'-]{1,30}\z/.freeze

  attr_reader :total_volume, :occupied_volume

  validate :company_name, :presence
  validate :company_name, :format, with: COMPANY_NAME_FORMAT

  def initialize(company_name, total_volume)
    super()
    @company_name = company_name
    @total_volume = total_volume
    @occupied_volume = 0
    validate!
  end

  def occupy_volume(volume)
    raise "Недостаточно свободного объема" if volume > available_volume
    @occupied_volume += volume
  end

  def occupied_volume
    @occupied_volume
  end

  def available_volume
    @total_volume - @occupied_volume
  end
end
