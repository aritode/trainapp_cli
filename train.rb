require_relative 'modules/manufacturer_name'
require_relative 'modules/instance_counter'

# Train
class Train
  include ManufacturerName
  include InstanceCounter
  attr_reader :speed, :number, :carriages, :type, :route

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type = :cargo)
    @number = number
    @type = type if %i[cargo passenger].include?(type)
    @carriages = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def accelerate
    @speed += 10 if @speed < 100
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    @carriages << carriage if @speed.zero?
  end

  def remove_carriage
    @carriages.pop if @speed.zero? && !carriages.empty?
  end

  def route=(route)
    @route = route
    @station_index = 0
    current_station.accept_train(self)
  end

  def current_station
    @route.stations[@station_index]
  end

  def move_next
    return if next_station.nil?
    move_train(1)
  end

  def move_previous
    return if previous_station.nil?
    move_train(-1)
  end

  def next_station
    @route.stations[@station_index + 1] if @station_index < @route.stations.size - 1
  end

  def previous_station
    @route.stations[@station_index - 1] if @station_index.positive?
  end

  def to_s
    "Train N:#{number} Type:#{type} Carriages:#{carriages.size}"
  end

  private

  def move_train(delta_index)
    accelerate
    current_station.release_train(self)
    @station_index += delta_index
    current_station.accept_train(self)
    stop
  end
end
