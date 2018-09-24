# frozen_string_literal: true

class MainMenu
  def initialize
    @trains = []
    @routes = []
  end

  def init
    choose_step
  end

  private

  def choose_step
    loop do
      display_menu
      user_choice = gets.to_i
      abort 'Good bye!' if user_choice.zero?
      check_user_input(user_choice)
    end
  end

  def display_menu
    show_header('MAIN MENU')
    puts
    puts <<~DISPLAY_MENU
      1. Create Station
      2. Create Train
      3. Create Route
      4. Manage Stations in Routes (Add/Remove)
      5. Assign Route to Train
      6. Add Carriage to Train
      7. Remove Carriage from Train
      8. Move Train on the Route (Next/Previous)
      9. Show List of Stations and Trains on the Stations
      10. Take Seat or Fill Volume in Carriage
      0. QUIT
    DISPLAY_MENU
    print '=> '
  end

  def check_user_input(user_choice)
    case user_choice
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 4
      manage_stations_in_route
    when 5
      assign_route_to_train
    when 6
      add_carriage_to_train
    when 7
      remove_carriage_from_train
    when 8
      move_train_by_route
    when 9
      print_stations_and_trains
    when 10
      take_seat_volume_carriage
    else
      display_menu
    end
  end

  def create_station(title = '[CREATE] Please enter Station name to create:')
    user_input = characters_user_input(title)
    station = Station.new(user_input)
    puts "\n[SUCCESS] Station: #{station} created!"
  rescue StandardError => e
    show_error_message(e)
    retry
  end

  #
  # Create Train
  # ============
  #
  # create_train(title = '[CREATE] Please choose Train type:')
  #

  def create_train(title = '[CREATE] Please choose Train type:')
    train_type = ask_choose_train_type(title)
    user_input_number = ask_train_number

    train = train_type.new(user_input_number)
    @trains << train
    puts "\n[SUCCESS] #{train} created!"
  rescue StandardError => e
    show_error_message(e)
    retry
  end

  def ask_choose_train_type(title)
    types = [CargoTrain, PassengerTrain]
    user_input = ordered_list_user_input(title, types)
    types[user_input - 1]
  end

  def ask_train_number
    title = 'Please enter Train number:'
    characters_user_input(title)
  end

  #
  # Create Route
  # ============
  #
  # create_route
  #

  def create_route
    return create_route_core unless Station.all.size < 2

    show_for_action_you_need('new Route',
                             '2 Stations',
                             Station.all.count)

    user_input = ask_yes_no_to_create('Station')
    return if user_input == 2

    create_station
    create_route
  end

  #
  # create_route_core
  #

  def create_route_core
    user_input_first = ask_input_choose_route_station('first')
    user_input_last = ask_input_choose_route_station('last')

    route = Route.new(Station.all[user_input_first - 1],
                      Station.all[user_input_last - 1])
    @routes << route
    puts "\n[SUCCESS] Route: #{route} created!"
  rescue StandardError => e
    show_error_message(e)
    retry
  end

  def ask_input_choose_route_station(name)
    title = "Please choose Route #{name} Station:"
    ordered_list_user_input(title, Station.all)
  end

  #
  # Manage Stations in Route
  # ========================
  #
  # manage_stations_in_route
  #

  def manage_stations_in_route
    return manage_stations_in_route_core unless @routes.empty?

    show_for_action_you_need('managing Stations in Routes',
                             '1 Route',
                             @routes.count)

    user_input = ask_yes_no_to_create('Route')
    return if user_input == 2

    create_route
    manage_stations_in_route
  end

  #
  # manage_stations_in_route_core
  #

  def manage_stations_in_route_core
    user_input_route = ask_manage_stations_in_route

    user_route = @routes[user_input_route - 1]
    user_input = ask_add_or_remove_station

    action_manage_stations_in_route_core(user_input, user_route)
  end

  def ask_manage_stations_in_route
    title = 'Please choose Route in which you want Add/Remove Stations'
    ordered_list_user_input(title, @routes)
  end

  def ask_add_or_remove_station
    title = 'Please choose action:'
    options = ['Add station',
               'Remove station',
               'No, let\'s go Back',
               'No, let\'s go to Main Menu']
    ordered_list_user_input(title, options)
  end

  def action_manage_stations_in_route_core(user_input, user_route)
    case user_input
    when 1
      add_station_to_route(user_route)
    when 2
      remove_station_from_route(user_route)
    when 3
      manage_stations_in_route_core
    end
  end

  #
  # Add Station to the Route
  # ========================
  #
  # add_station_to_route(route)
  #

  def add_station_to_route(route)
    available_stations = Station.all.reject { |item| route.stations.include?(item) }

    return add_station_to_route_core(available_stations, route) unless available_stations.empty?

    show_no_available_stations('to Add to the Route')

    user_input = ask_yes_no_to_create('Station')

    action_add_station_to_route(user_input, route)
  end

  def show_no_available_stations(description)
    puts "\nThere is no available Stations #{description}"
  end

  def action_add_station_to_route(user_input, route)
    case user_input
    when 1
      create_station
      add_station_to_route(route)
    when 2
      display_menu
    end
  end

  def add_station_to_route_core(available_stations, route)
    user_input_station = ask_add_station_to_route_core(available_stations)
    user_station = available_stations[user_input_station - 1]

    route.add(user_station)
    puts "\n[SUCCESS] Station: #{user_station} added to the Route: #{route}"
  end

  def ask_add_station_to_route_core(available_stations)
    title = 'Please choose Station to Add to Route'
    ordered_list_user_input(title, available_stations)
  end

  #
  # Remove Station from Route
  # =========================
  #
  # remove_station_from_route(route)
  #

  def remove_station_from_route(route)
    available_stations = Station.all.select do |item|
      item != route.stations.first && item != route.stations.last
    end

    unless available_stations.empty?
      return remove_station_from_route_core(available_stations, route)
    end

    show_no_available_stations('which you can Remove from Route')
    user_input = ask_add_station_to_route

    action_remove_station_from_route(user_input, route)
  end

  def ask_add_station_to_route
    title = 'Do you want to add Station to Route?'
    custom_list = ['Yes, let\'s Add Station',
                   'No, let\'s go to Main Menu']
    ordered_list_user_input(title, custom_list)
  end

  def action_remove_station_from_route(user_input, route)
    case user_input
    when 1
      add_station_to_route(route)
      manage_stations_in_route
    when 2
      display_menu
    end
  end

  def remove_station_from_route_core(available_stations, route)
    title = 'Please choose Station to Remove from Route'
    user_input_station = ordered_list_user_input(title, available_stations)
    user_station = available_stations[user_input_station - 1]
    route.remove(user_station)
    puts "\n[SUCCESS] Station: #{user_station} removed from the Route: #{route}"
  end

  #
  # Assign Route to Train
  # =====================
  #
  # assign_route_to_train
  #

  def assign_route_to_train
    return create_1_train_to_assign_route_to_train if @trains.empty?
    return create_1_route_to_assign_route_to_train if @routes.empty?

    assign_route_to_train_core
  end

  def create_1_train_to_assign_route_to_train
    show_for_action_you_need('assigning Route to Train',
                             '1 Train',
                             @trains.count)

    user_input = ask_yes_no_to_create('Train')
    return if user_input == 2

    create_train
    assign_route_to_train
  end

  def create_1_route_to_assign_route_to_train
    show_for_action_you_need('assigning Route to Train',
                             '1 Route',
                             @routes.count)

    user_input = ask_yes_no_to_create('Route')
    return if user_input == 2

    create_route
    assign_route_to_train
  end

  #
  # assign_route_to_train_core
  #

  def assign_route_to_train_core
    user_input = ask_choose_train_for_route
    user_train = @trains[user_input - 1]

    user_input = ask_choose_route_for_train
    user_route = @routes[user_input - 1]

    user_train.route = user_route
    puts "[SUCCESS] #{user_train} assigned to Route: #{user_route}"
  end

  def ask_choose_train_for_route
    title = 'Please choose Train for assigning Route:'
    ordered_list_user_input(title, @trains)
  end

  def ask_choose_route_for_train
    title = 'Please choose Route for assignment to Train:'
    ordered_list_user_input(title, @routes)
  end

  #
  # Add Carriage to Train
  #
  # add_carriage_to_train
  #

  def add_carriage_to_train
    if @trains.empty?
      create_1_train_to_add_carriage_to_train
    else
      user_input = ask_choose_train_for_adding_carriages
      user_train = @trains[user_input - 1]

      add_carriage_to_train_core(user_train)
    end
  rescue StandardError => e
    show_error_message(e)
    retry
  end

  def create_1_train_to_add_carriage_to_train
    show_for_action_you_need('adding Carriage to Train',
                             '1 Train',
                             @trains.count)

    user_input = ask_yes_no_to_create('Train')
    return if user_input == 2

    create_train
    add_carriage_to_train
  end

  def ask_choose_train_for_adding_carriages
    title = 'Please choose Train for adding Carriage:'
    ordered_list_user_input(title, @trains)
  end

  #
  # add_carriage_to_train_core(train)
  #

  def add_carriage_to_train_core(train)
    user_input = ask_enter_carriage_number

    carriage = if train.is_a? CargoTrain
                 create_cargo_carriage(user_input)
               elsif train.is_a? PassengerTrain
                 create_passenger_carriage(user_input)
               else
                 raise 'ERROR in Train Type'
               end

    train.add_carriage(carriage)
    print "\n[SUCCESS] #{carriage} was added to #{train}\n"
  end

  def ask_enter_carriage_number
    title = 'Please enter Carriage number:'
    characters_user_input(title)
  end

  def ask_cargo_carriage_max_volume
    title = 'Please enter Cargo Carriage maximum volume:'
    characters_user_input(title).to_i
  end

  def ask_passenger_carriage_max_seats
    title = 'Please enter Passenger Carriage maximum number of seats:'
    characters_user_input(title).to_i
  end

  def create_cargo_carriage(user_input)
    user_input_volume = ask_cargo_carriage_max_volume
    CargoCarriage.new(user_input, user_input_volume)
  end

  def create_passenger_carriage(user_input)
    user_input_volume = ask_passenger_carriage_max_seats
    PassengerCarriage.new(user_input, user_input_volume)
  end

  #
  # Remove Carriage from Train
  #
  # remove_carriage_from_train
  #

  def remove_carriage_from_train
    return create_1_train_for_removing_carriage_from_train if @trains.empty?

    user_input = ask_choose_train_to_remove_carriage
    user_train = @trains[user_input - 1]

    if user_train.carriages.empty?
      return create_1_carriage_for_removing_carriage_from_train(user_train)
    end

    carriage = user_train.remove_carriage
    puts "\n[SUCCESS] #{carriage} was removed from #{user_train}"
  end

  def ask_choose_train_to_remove_carriage
    title = 'Please choose Train to remove Carriage:'
    ordered_list_user_input(title, @trains)
  end

  def create_1_train_for_removing_carriage_from_train
    show_for_action_you_need('removing Carriage from Train',
                             '1 Train',
                             @trains.count)

    user_input = ask_yes_no_to_create('Train')
    return if user_input == 2

    create_train
    remove_carriage_from_train
  end

  def create_1_carriage_for_removing_carriage_from_train(user_train)
    show_for_action_you_need('removing Carriage from Train',
                             '1 Carriage',
                             user_train.carriages.count)

    user_input = ask_yes_no_to_create('Carriage')
    return if user_input == 2

    add_carriage_to_train
  end

  #
  # Move Train on the Route (Next/Previous)
  #
  # move_train_by_route
  #

  def move_train_by_route
    return action_no_trains_on_route unless @trains.any?(&:route)

    available_trains_on_route = @trains.select(&:route)

    user_input = ask_choose_train_on_route_to_move(available_trains_on_route)
    user_train = @trains[user_input - 1]

    show_current_station(user_train)

    user_input = ask_direction_to_move_train(user_train)
    move_train_on_user_input(user_input, user_train)
  end

  def ask_direction_to_move_train(user_train)
    title = 'Please Choose direction: '
    options = [next_station(user_train),
               previous_station(user_train),
               "Ok, let's go to Main Menu"]
    ordered_list_user_input(title, options)
  end

  def move_train_on_user_input(user_input, user_train)
    case user_input
    when 1
      move_train_next_station(user_train)
    when 2
      move_train_previous_station(user_train)
    end
  end

  def move_train_next_station(user_train)
    user_train.move_next
    show_current_station(user_train)
    move_train_by_route
  end

  def move_train_previous_station(user_train)
    user_train.move_previous
    show_current_station(user_train)
    move_train_by_route
  end

  def action_no_trains_on_route
    show_for_action_you_need('moving Train on the Route',
                             '1 Train assigned to Route',
                             0)
    assign_route_to_train
  end

  def ask_choose_train_on_route_to_move(available_trains_on_route)
    title = 'Please choose Train on Route to move:'
    ordered_list_user_input(title, available_trains_on_route)
  end

  def show_current_station(user_train)
    puts "\n[INFO] Current Station of Train: #{user_train.current_station}"
  end

  def next_station(user_train)
    if user_train.next_station.nil?
      "Stay on Current Station: #{user_train.current_station} (You're on Last station)"
    else
      "Next Station: #{user_train.next_station}"
    end
  end

  def previous_station(user_train)
    if user_train.previous_station.nil?
      "Stay on Current Station: #{user_train.current_station} (You're on First station)"
    else
      "Previous Station: #{user_train.previous_station}"
    end
  end

  #
  # Show List of Stations and Trains on the Stations
  #
  # print_stations_and_trains
  #

  def print_stations_and_trains
    show_all_trains_on_stations_header
    return show_empty_message_on_stations if Station.all.empty?

    Station.all.each do |station|
      show_name_of_station_header(station)
      show_empty_message_on_stations unless station.trains.any?

      station.each_train do |train|
        puts train
        train.each_carriage { |carriage| show_formatted_item(carriage) }
      end
    end
  end

  def show_all_trains_on_stations_header
    title = 'Show all Trains on all Stations'
    show_header(title)
  end

  def show_name_of_station_header(station)
    title = "\nStation: #{station}"
    show_header(title)
  end

  def show_formatted_item(item)
    puts "    #{item}"
  end

  def show_empty_message_on_stations
    puts 'Empty'
  end

  #
  # Take Seat or Fill Volume in Carriage
  #
  # take_seat_volume_carriage
  #

  def take_seat_volume_carriage
    if @trains.empty?
      create_1_train_to_take_seat_volume_carriage
    else
      user_input = ask_choose_train
      user_train = @trains[user_input - 1]

      if user_train.carriages.empty?
        create_1_carriage_to_take_seat_volume_carriage(user_train)
      else
        take_seat_volume_carriage_core(user_train)
      end
    end
  end

  def create_1_train_to_take_seat_volume_carriage
    show_for_action_you_need('filling volume (or taking seat)',
                             '1 Train',
                             @trains.count)

    user_input = ask_yes_no_to_create('Train')
    return if user_input == 2

    create_train
    take_seat_volume_carriage
  end

  def create_1_carriage_to_take_seat_volume_carriage(user_train)
    show_for_action_you_need('filling volume (or taking seat)',
                             '1 Carriage in Train',
                             user_train.carriages.count)

    user_input = ask_yes_no_to_create('Carriage')
    return if user_input == 2

    add_carriage_to_train_core(user_train)
  end

  def ask_choose_train
    title = 'Please choose Train:'
    ordered_list_user_input(title, @trains)
  end

  #
  # take_seat_volume_carriage_core(user_train)
  #

  def take_seat_volume_carriage_core(user_train)
    user_input = ask_choose_carriage(user_train)
    user_carriage = user_train.carriages[user_input - 1]

    if user_carriage.is_a? CargoCarriage
      user_input = ask_volume_to_fill
      show_filled_volume(user_input, user_carriage)

    elsif user_carriage.is_a? PassengerCarriage
      show_taken_seats(user_carriage)

    else
      raise 'ERROR in Carriage Type'
    end
  end

  def ask_choose_carriage(user_train)
    title = 'Please choose Carriage:'
    ordered_list_user_input(title, user_train.carriages)
  end

  def ask_volume_to_fill
    title = 'Please enter Volume to fill:'
    characters_user_input(title).to_i
  end

  def show_filled_volume(user_input, user_carriage)
    if user_carriage.take_volume(user_input)
      puts "\n[SUCCESS] Volume #{user_input} is filled"
    else
      puts "\n[ERROR] There is no enough available volume"
    end
    puts user_carriage
  end

  def show_taken_seats(user_carriage)
    if user_carriage.take_seat
      puts "\n[SUCCESS] Seat is taken"
    else
      puts "\n[ERROR] There is no available seats"
    end
    puts user_carriage
  end

  #
  # Helper methods
  #

  def show_for_action_you_need(action_name, to_name, counter)
    puts "\n[INFO] For #{action_name} you need at least #{to_name}"
    puts "You have: #{counter}"
  end

  def ask_yes_no_to_create(name)
    title = "Do you want to create #{name}?"
    custom_list = ["Yes, let's create #{name}",
                   'No, let\'s go Back']
    ordered_list_user_input(title, custom_list)
  end

  def show_error_message(error)
    puts "\n[ERROR] #{error}"
    puts 'Please, try again'
  end

  def show_header(title)
    puts
    puts title
    puts '=' * title.length
  end

  def characters_user_input(title)
    show_header(title)
    print '=> '
    gets.chomp.strip
  end

  def ordered_list_user_input(title, items_array)
    show_header(title)
    items_array.each.with_index(1) do |item, i|
      puts "#{i}) #{item}"
    end
    print '=> '
    check_list_user_input(items_array)
  end

  def check_list_user_input(items_array)
    user_input = gets.to_i
    max_value = items_array.size
    if (1..max_value).cover?(user_input)
      user_input
    else
      puts "\nPlease enter number from 1 to #{max_value}"
      print '=> '
      check_list_user_input(items_array)
    end
  end
end
