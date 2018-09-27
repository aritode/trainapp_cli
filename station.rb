# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/validation'

# Station
class Station
  include InstanceCounter
  include Validation
  attr_reader :name, :trains

  validate :name, :presence

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
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

  def each_train
    trains.each { |train| yield train } if block_given?
  end

  def to_s
    name
  end

  private

  def validate!
    message = "Station #{name} is already in Stations"
    raise message if Station.all.any? { |item| item.name.casecmp(@name).zero? }

    super
  end
end
