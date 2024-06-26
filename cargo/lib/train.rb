require_relative 'company'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Company
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^[\w]{3}-?[\w]{2}$/i.freeze
  COMPANY_NAME_FORMAT = /\A[a-zA-Z\s&'-]{1,30}\z/.freeze

  @@trains = {}

  attr_reader :number, :carriages, :speed, :route, :current_station_index
  attr_accessor :company_name

  validate :number, :presence
  validate :number, :format, with: NUMBER_FORMAT
  validate :company_name, :presence
  validate :company_name, :format, with: COMPANY_NAME_FORMAT

  def initialize(number, company_name)
    @number = number
    @company_name = company_name
    @carriages = []
    @speed = 0
    @route = nil
    @current_station_index = nil
    validate!
    @@trains[number] = self
    register_instance
  end

  def self.find(number)
    @@trains[number]
  end

  def add_carriage(carriage)
    return unless type_of_carriage?(carriage)
    return unless stopped?

    @carriages << carriage
  end

  def remove_carriage(carriage)
    return unless stopped?

    def update_carriage(updated_carriage)
      index = @carriages.index { |carriage| carriage.object_id == updated_carriage.object_id }
      @carriages[index] = updated_carriage if index
    end

    @carriages.delete(carriage)
  end

  def speed_up(value)
    @speed += value
  end

  def slow_down(value)
    @speed -= value
    @speed = 0 if @speed < 0
  end

  def stopped?
    @speed.zero?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.add_train(self)
  end

  def move_forward
    return unless next_station

    current_station.remove_train(self)
    @current_station_index += 1
    current_station.add_train(self)
  end

  def move_backward
    return unless previous_station

    current_station.remove_train(self)
    @current_station_index -= 1
    current_station.add_train(self)
  end

  def current_station
    @route.stations[@current_station_index] if @route
  end

  def next_station
    @route.stations[@current_station_index + 1] if @route && @current_station_index < @route.stations.size - 1
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @route && @current_station_index > 0
  end

  def each_carriage
    return @carriages.to_enum unless block_given?
    @carriages.each { |carriage| yield(carriage) }
  end

  private

  def type_of_carriage?(carriage)
    raise NotImplementedError, 'Этот метод должен быть переопределен в подклассах'
  end
end
