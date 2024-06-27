# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@validations, [])
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(*args)
      validations << args
    end
  end

  def validate!
    self.class.validations.each do |validation|
      name, type, *params = validation
      value = instance_variable_get("@#{name}")
      send("validate_#{type}", name, value, *params)
    end
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate_presence(name, value)
    raise "#{name} can't be nil or empty" if value.nil? || value.to_s.empty?
  end

  def validate_format(name, value, format)
    raise "#{name} doesn't match the format" unless value.to_s.match?(format)
  end

  def validate_type(name, value, klass)
    raise "#{name} is not of type #{klass}" unless value.is_a?(klass)
  end
end
