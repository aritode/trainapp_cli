require_relative 'station'
require_relative 'route'
require_relative 'train'

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

train_one = Train.new(11, :passenger, 9)
train_two = Train.new(15)
train_three = Train.new(100, :cargo, 20)

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
