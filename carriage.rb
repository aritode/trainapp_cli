# frozen_string_literal: true

require_relative 'modules/manufacturer_name'
require_relative 'modules/validation'

# Carriage
class Carriage
  include ManufacturerName
  include Validation

  attr_reader :volume_max, :volume_taken

  validate :number, :presence

  def initialize(number, volume_max)
    @number = number
    @volume_max   = volume_max
    @volume_taken = 0
    validate!
  end

  def take_volume(amount)
    @volume_taken += amount if amount <= available_volume && amount.positive?
  end

  def available_volume
    volume_max - volume_taken
  end

  def to_s
    "Carriage № #{@number}, type: #{self.class}"
  end
end
