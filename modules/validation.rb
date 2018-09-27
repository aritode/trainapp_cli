# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= {}
    end

    def validate(attr_name, type, options = nil)
      validations[attr_name] ||= []
      validations[attr_name] << [type, options]
    end
  end

  module InstanceMethods
    def valid?
      validation!
      true
    rescue StandardError
      false
    end

    def validate!
      self.class.validations.each do |attr_name, params|
        attr_value = instance_variable_get("@#{attr_name}")
        params.each do |method_name, option|
          method_name = "validate_#{method_name}"
          send(method_name, attr_name, attr_value, option)
        end
      end
    end

    protected

    def validate_presence(attr_name, attr_value, _option)
      if attr_value.to_s.empty?
        raise "#{self.class} @#{attr_name} can't be empty"
      end
    end

    def validate_format(attr_name, attr_value, format)
      if attr_value !~ format
        raise "#{self.class} must be with correct @#{attr_name} format: #{format}"
      end
    end

    def validate_type(attr_name, attr_name_value, type)
      message = "#{self.class} @#{attr_name} must be correct type: #{type}"
      raise message unless attr_name_value.is_a?(type)
    end
  end
end
