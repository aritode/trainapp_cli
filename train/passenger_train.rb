# frozen_string_literal: true

# Passenger Train
class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :passenger)
  end

  def add_carriage(carriage)
    super if carriage.instance_of? PassengerCarriage
  end
end
