# frozen_string_literal: true

module Accessors
  def attr_accessors_with_history(*args)
    args.each do |attr_name|
      attr_name_history = "#{attr_name}_history"

      attr_reader attr_name

      define_method(attr_name_history) do
        instance_variable_get("@#{attr_name_history}") || []
      end

      define_method("#{attr_name}=") do |value|
        history_array = send(attr_name_history) << value

        instance_variable_set("@#{attr_name_history}", history_array)
        instance_variable_set("@#{attr_name}", value)
      end
    end
  end

  def strong_attr_accessor(attr_name, attr_class)
    attr_reader attr_name

    define_method("#{attr_name}=") do |value|
      message = "Class of value: #{value} is not #{attr_class}"
      raise TypeError, message unless value.is_a? attr_class
      instance_variable_set("@#{attr_name}", value)
    end
  end
end
