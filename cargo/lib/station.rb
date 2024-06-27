# frozen_string_literal: true

require_relative 'accessors'
require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation
  include Accessors

  attr_reader :trains

  attr_accessor_with_history :name

  validate :name, :presence
  validate :name, :format, /^[a-zA-Z\s-]+$/
  validate :name, :type, String

  @stations = []

  class << self
    attr_reader :stations

    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.stations << self
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  def remove_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.instance_of?(type) }
  end

  def each_train(&)
    @trains.each(&)
  end
end
