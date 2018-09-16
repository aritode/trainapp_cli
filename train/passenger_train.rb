# Passenger Train
class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end

  def add_carriage(carriage)
    super if carriage.instance_of? PassengerCarriage
  end
end
