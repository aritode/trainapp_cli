# frozen_string_literal: true

# Passenger Carriage
class PassengerCarriage < Carriage
  alias total_seats volume_max
  alias reserved_seats volume_taken

  alias seats_available available_volume

  def initialize(number, total_seats)
    super(number, total_seats)
  end

  def take_volume
    super(1)
  end

  alias take_seat take_volume

  def to_s
    "#{super} - SEATS Available: #{seats_available}, Reserved: #{reserved_seats}"
  end

  private

  def validate!
    raise 'Maximum number of Seats must be greater than 0' if total_seats.zero?
  end
end
