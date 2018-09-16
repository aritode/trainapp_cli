require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'train/passenger_train'
require_relative 'train/cargo_train'

require_relative 'carriage'
require_relative 'carriage/passenger_carriage'
require_relative 'carriage/cargo_carriage'

# Station Class

station_one = Station.new('Saint-Petersburg')
station_two = Station.new('Moscow')

station_three = Station.new('N.Novgorod')
station_four = Station.new('Tver')

# Route Class

route_one = Route.new(station_one, station_two)

3.times { route_one.add(station_three) }
route_one.add(station_four)
puts route_one.stations

puts

route_one.remove(station_one) # testing
route_one.remove(station_three)

puts route_one.stations

# Train class

train_one = PassengerTrain.new(11)
train_two = Train.new(15)
train_three = CargoTrain.new(100)

# Carriages

cargo_car = CargoCarriage.new(22)
cargo_car_two = CargoCarriage.new(44)
passenger_car = PassengerCarriage.new(11)

train_one.add_carriage(cargo_car) # testing
train_one.add_carriage(passenger_car)
train_three.add_carriage(cargo_car)
train_three.add_carriage(passenger_car) # testing
train_three.add_carriage(cargo_car_two)

# Train class with Route

train_one.route = route_one
puts train_one
train_two.route = route_one
train_three.route = route_one
puts
puts "Trains on station: #{station_one}"
puts station_one.trains
puts

5.times { train_one.move_next }
puts "Trains on station: #{station_one}"
puts station_one.trains
puts "Trains on station: #{station_two}"
puts station_two.trains

5.times { train_one.move_previous }
puts "Trains on station: #{station_one}"
puts station_one.trains
puts "Trains on station: #{station_two}"
puts station_two.trains
puts
