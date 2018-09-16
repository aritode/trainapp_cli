class CargoTrain < Train
  def initialize(number, carriages = 0)
    super(number, :cargo, carriages)
  end
end
