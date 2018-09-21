# frozen_string_literal: true

# Cargo Train
class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end

  def add_carriage(carriage)
    super if carriage.instance_of? CargoCarriage
  end
end
