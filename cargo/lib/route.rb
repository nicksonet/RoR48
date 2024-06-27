# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'
require_relative 'station' # Добавьте эту строку, если она отсутствует

class Route
  include InstanceCounter
  include Validation
  include Accessors

  attr_reader :stations
  attr_accessor :start_station, :end_station

  validate :start_station, :presence
  validate :end_station, :presence
  validate :start_station, :type, Station
  validate :end_station, :type, Station

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @stations = [start_station, end_station]
    validate!
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    return if [start_station, end_station].include?(station)

    @stations.delete(station)
  end

  def list_stations
    @stations.each { |station| puts station.name }
  end
end
