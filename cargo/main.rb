# frozen_string_literal: true

require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/train'
require_relative 'lib/passenger_train'
require_relative 'lib/cargo_train'
require_relative 'lib/passenger_carriage'
require_relative 'lib/cargo_carriage'
require_relative 'lib/company'
require_relative 'lib/instance_counter'
require_relative 'lib/validation'
require_relative 'modules/train_operations'
require_relative 'modules/station_operations'
require_relative 'modules/route_operations'
require_relative 'modules/carriage_operations'
require_relative 'modules/ui_operations'
require_relative 'modules/test_data_operations'

# Main class for managing the railway system
class Main
  include TrainOperations
  include StationOperations
  include RouteOperations
  include CarriageOperations
  include UIOperations
  include TestDataOperations

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def run
    loop do
      print_menu
      choice = user_input.to_i
      break if choice.zero?

      process_user_choice(choice)
    end
  end

  private

  def process_user_choice(choice)
    case choice
    when 1 then create_station
    when 2 then create_train
    when 3 then create_route
    when 4 then add_station_to_route
    when 5 then remove_station_from_route
    when 6 then assign_route_to_train
    when 7 then add_carriage_to_train
    when 8 then remove_carriage_from_train
    when 9 then move_train_forward
    when 10 then move_train_backward
    when 11 then list_stations_and_trains
    when 12 then find_train
    when 13 then show_carriage_info
    when 14 then take_seat_in_carriage
    when 15 then occupy_volume_in_carriage
    when 16 then show_trains_on_station
    when 17 then create_test_data_and_show_info
    else
      print_error('Неверный выбор, попробуйте снова')
    end
  end
end

Main.new.run
