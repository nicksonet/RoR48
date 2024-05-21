require_relative 'lib/station'
require_relative 'lib/route'
require_relative 'lib/train'
require_relative 'lib/passenger_train'
require_relative 'lib/cargo_train'
require_relative 'lib/passenger_carriage'
require_relative 'lib/cargo_carriage'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def run
    loop do
      print_menu
      choice = gets.chomp.to_i
      break if choice == 0

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
      else
        puts "Неверный выбор, попробуйте снова"
      end
    end
  end

  private

  def print_menu
    puts "Выберите действие:"
    puts "1. Создать станцию"
    puts "2. Создать поезд"
    puts "3. Создать маршрут"
    puts "4. Добавить станцию в маршрут"
    puts "5. Удалить станцию из маршрута"
    puts "6. Назначить маршрут поезду"
    puts "7. Добавить вагон к поезду"
    puts "8. Отцепить вагон от поезда"
    puts "9. Переместить поезд вперед по маршруту"
    puts "10. Переместить поезд назад по маршруту"
    puts "11. Просмотреть список станций и список поездов на станции"
    puts "0. Выйти"
  end

  def create_station
    puts "Введите название станции:"
    name = gets.chomp
    @stations << Station.new(name)
    puts "Станция #{name} создана"
  end

  def create_train
    puts "Выберите тип поезда:"
    puts "1. Пассажирский"
    puts "2. Грузовой"
    type = gets.chomp.to_i
    puts "Введите номер поезда:"
    number = gets.chomp
    case type
    when 1
      @trains << PassengerTrain.new(number)
      puts "Пассажирский поезд #{number} создан"
    when 2
      @trains << CargoTrain.new(number)
      puts "Грузовой поезд #{number} создан"
    else
      puts "Неверный тип поезда"
    end
  end

  def create_route
    puts "Введите начальную станцию маршрута:"
    start_station = select_station
    puts "Введите конечную станцию маршрута:"
    end_station = select_station
    @routes << Route.new(start_station, end_station)
    puts "Маршрут создан"
  end

  def add_station_to_route
    route = select_route
    station = select_station
    route.add_station(station)
    puts "Станция добавлена в маршрут"
  end

  def remove_station_from_route
    route = select_route
    station = select_station
    route.remove_station(station)
    puts "Станция удалена из маршрута"
  end

  def assign_route_to_train
    train = select_train
    route = select_route
    train.assign_route(route)
    puts "Маршрут назначен поезду"
  end

  def add_carriage_to_train
    train = select_train
    carriage = train.is_a?(PassengerTrain) ? PassengerCarriage.new : CargoCarriage.new
    train.add_carriage(carriage)
    puts "Вагон добавлен к поезду"
  end

  def remove_carriage_from_train
    train = select_train
    train.remove_carriage(train.carriages.last)
    puts "Вагон отцеплен от поезда"
  end

  def move_train_forward
    train = select_train
    train.move_forward
    puts "Поезд перемещен вперед"
  end

  def move_train_backward
    train = select_train
    train.move_backward
    puts "Поезд перемещен назад"
  end

  def list_stations_and_trains
    @stations.each do |station|
      puts "Станция: #{station.name}"
      station.trains.each do |train|
        puts "  Поезд #{train.number}, тип: #{train.class}, вагонов: #{train.carriages.size}"
      end
    end
  end

  def select_station
    puts "Выберите станцию из списка:"
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    index = gets.chomp.to_i - 1
    @stations[index]
  end

  def select_train
    puts "Выберите поезд из списка:"
    @trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" }
    index = gets.chomp.to_i - 1
    @trains[index]
  end

  def select_route
    puts "Выберите маршрут из списка:"
    @routes.each_with_index { |route, index| puts "#{index + 1}. #{route.stations.map(&:name).join(' - ')}" }
    index = gets.chomp.to_i - 1
    @routes[index]
  end
end

Main.new.run
