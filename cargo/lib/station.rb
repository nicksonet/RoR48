# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  @stations = []
  class << self
    attr_reader :stations

    def all
      @stations
    end
  end

  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :format, with: /\A[a-zA-Z\s-]{1,30}\z/

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
    @trains.select { |train| train.is_a?(type) }
  end

  def each_train(&)
    return to_enum(:each_train) unless block_given?

    @trains.each(&)
  end
end
