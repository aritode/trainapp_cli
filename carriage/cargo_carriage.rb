# frozen_string_literal: true

# Cargo Carriage
class CargoCarriage < Carriage
  validate :number, :presence

  def initialize(number, volume_max)
    super(number, volume_max)
  end

  def to_s
    "#{super} - VOLUME Available: #{available_volume}, Filled: #{volume_taken}"
  end

  private

  def validate!
    raise 'Maximum Volume must be greater than 0' if volume_max.zero?
    super
  end
end
