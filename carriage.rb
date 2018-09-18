require_relative 'modules/manufacturer_name'
require_relative 'modules/validation'

# Carriage
class Carriage
  include ManufacturerName
  include Validation

  def initialize(number)
    @number = number
    validate!
  end

  def to_s
    "Carriage № #{@number}, type: #{self.class}"
  end

  protected

  def validate!
    raise 'Carriage number can\'t be empty' if @number.empty?
    true
  end
end
