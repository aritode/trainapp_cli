require_relative 'modules/manufacturer_name'

# Carriage
class Carriage
  include ManufacturerName

  def initialize(number)
    @number = number
  end

  def to_s
    "Carriage № #{@number}, type: #{self.class}"
  end
end
