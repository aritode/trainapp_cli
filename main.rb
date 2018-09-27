# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'train/passenger_train'
require_relative 'train/cargo_train'

require_relative 'carriage'
require_relative 'carriage/passenger_carriage'
require_relative 'carriage/cargo_carriage'

require_relative 'main_menu'

app = MainMenu.new
app.init
