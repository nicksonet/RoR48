require_relative 'instance_counter'

class Station
  include InstanceCounter

  @@stations = []

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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
