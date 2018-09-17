# Station
class Station
  attr_reader :name, :trains
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
  end

  def accept_train(train)
    @trains << train unless @trains.include?(train)
  end

  def release_train(train)
    @trains.delete(train)
  end

  def by_type(type)
    trains.select { |train| train.type == type }
  end

  def to_s
    name
  end
end
