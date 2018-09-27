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
      raise "#{self.class} #{attr_name} can't be empty" if attr_value.to_s.empty?
    end

    def validate_format(attr_name, attr_value, format)
      message = "#{self.class} #{attr_name} must be in correct format: ###-## or ##### \
                 \nfull format in regex: #{format}"
      raise message unless attr_value&.match?(format)
    end

    def validate_type(attr_name, attr_name_value, type)
      message = "#{self.class} @#{attr_name} must be correct type: #{type}"
      raise message unless attr_name_value.is_a?(type)
    end
  end
end
