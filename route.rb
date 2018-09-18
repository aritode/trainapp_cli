require_relative 'modules/instance_counter'

# Route
class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    register_instance
  end

  def add(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def remove(station)
    @stations.delete(station) unless [@stations.first, @stations.last].include?(station)
  end

  def to_s
    "#{stations.first} - #{stations.last}"
  end

  private

  def validate!
    raise 'Incorrect First Station type' unless @stations.first.instance_of? Station
    raise 'Incorrect Last Station type' unless @stations.last.instance_of? Station

    if @stations.first == @stations.last
      raise 'First Station must be different than Last Station'
    end

    true
  end
end
