require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  @@stations = []

  attr_reader :name, :trains

  STATION_NAME_FORMAT = /\A[a-zA-Z\s-]{1,30}\z/.freeze

  validate :name, :presence
  validate :name, :format, with: STATION_NAME_FORMAT

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def self.all
    @@stations
  end

  def add_train(train)
    @trains << train
  end

  def remove_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.is_a?(type) }
  end
end
