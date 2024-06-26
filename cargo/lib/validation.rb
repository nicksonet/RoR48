# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(attr_name, type, options = {})
      validations << { attr_name:, type:, options: }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        value = instance_variable_get("@#{validation[:attr_name]}")
        send("validate_#{validation[:type]}", value, validation)
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate_presence(value, validation)
      return unless value.nil? || value.to_s.strip.empty?

      raise "#{validation[:attr_name].to_s.capitalize} не может быть пустым"
    end

    def validate_format(value, validation)
      return unless value !~ validation[:options][:with]

      raise "#{validation[:attr_name].to_s.capitalize} имеет неверный формат"
    end

    def validate_type(value, validation)
      return if value.is_a?(validation[:options])

      raise "#{validation[:attr_name].to_s.capitalize} должен быть типа #{validation[:options]}"
    end
  end
end
