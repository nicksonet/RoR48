# frozen_string_literal: true

require_relative 'company'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Train
  include Company
  include InstanceCounter
  include Validation
  include Accessors

  attr_reader :carriages, :route, :number

  attr_accessor_with_history :speed, :current_station_index

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  class << self
    def trains
      @trains ||= {}
    end

    def find(number)
      trains[number]
    end
  end

  def initialize(number, company_name)
    @number = number
    @carriages = []
    @speed = 0
    @route = nil
    @current_station_index = nil
    self.company_name = company_name
    validate!
    self.class.trains[number] = self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    @carriages << carriage if speed.zero? && attachable_carriage?(carriage)
  end

  def remove_carriage(carriage)
    @carriages.delete(carriage) if speed.zero? && !@carriages.empty?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.add_train(self)
  end

  def move_forward
    return unless next_station

    current_station.remove_train(self)
    self.current_station_index += 1
    current_station.add_train(self)
  end

  def move_backward
    return unless previous_station

    current_station.remove_train(self)
    self.current_station_index -= 1
    current_station.add_train(self)
  end

  def current_station
    @route.stations[@current_station_index] if @route
  end

  def next_station
    @route.stations[@current_station_index + 1] if @route && @current_station_index < @route.stations.size - 1
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @route && @current_station_index.positive?
  end

  def each_carriage(&)
    @carriages.each(&)
  end

  protected

  def attachable_carriage?(carriage)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
