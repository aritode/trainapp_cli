# Carriage
class Carriage
  def initialize(number)
    @number = number
  end

  def to_s
    "Carriage № #{@number}, type: #{self.class}"
  end
end
