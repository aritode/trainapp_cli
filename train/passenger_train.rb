class PassengerTrain < Train
  def initialize(number, carriages = 0)
    super(number, :passenger, carriages)
  end
end
