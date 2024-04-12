require_relative 'station'
require_relative 'route'
require_relative 'train'

# Создать станции
station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")

# Создать маршрут
route = Route.new(station1, station3)
route.add_station(station2)

# Создать поезд
train = Train.new("Train 1", "passenger", 10)

# Назначить маршрут поезду
train.assign_route(route)

# Переместить поезд вперед на одну станцию
train.go_forward

# Вывести текущую станцию поезда
puts train.current_station.name
