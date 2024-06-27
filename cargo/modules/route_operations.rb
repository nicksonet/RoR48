# frozen_string_literal: true

module RouteOperations
  def create_route
    puts 'Выберите начальную станцию маршрута:'
    start_station = select_station
    puts 'Выберите конечную станцию маршрута:'
    end_station = select_station
    route = Route.new(start_station, end_station)
    @routes << route
    puts 'Маршрут создан'
  rescue StandardError => e
    puts "Ошибка при создании маршрута: #{e.message}"
    retry
  end

  def add_station_to_route
    route = select_route
    station = select_station
    route.add_station(station)
    puts 'Станция добавлена в маршрут'
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def remove_station_from_route
    route = select_route
    station = select_station
    route.remove_station(station)
    puts 'Станция удалена из маршрута'
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def assign_route_to_train
    train = select_train
    route = select_route
    train.assign_route(route)
    puts 'Маршрут назначен поезду'
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def select_route
    puts 'Выберите маршрут из списка:'
    @routes.each_with_index { |route, index| puts "#{index + 1}. #{route.stations.map(&:name).join(' - ')}" }
    index = gets.chomp.to_i - 1
    @routes[index]
  end
end
