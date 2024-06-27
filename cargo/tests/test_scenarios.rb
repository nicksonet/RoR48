# rubocop:disable all
# frozen_string_literal: true

require_relative '../lib/train'
require_relative '../lib/station'
require_relative '../lib/route'
require_relative '../lib/passenger_train'
require_relative '../lib/cargo_train'
require_relative '../lib/passenger_carriage'
require_relative '../lib/cargo_carriage'

def run_test(description)
  puts "\n#{description}"
  yield
  puts "Тест пройден успешно"
rescue StandardError => e
  puts "Тест не пройден: #{e.message}"
end

puts 'Тестирование модуля Accessors:'

class TestAccessors
  include Accessors

  attr_accessor_with_history :test_attr
  strong_attr_accessor :test_strong_attr, String
end

test = TestAccessors.new

run_test("Проверка attr_accessor_with_history") do
  test.test_attr = 'First'
  test.test_attr = 'Second'
  test.test_attr = 'Third'
  raise "Неверное текущее значение" unless test.test_attr == 'Third'
  raise "Неверная история изменений" unless test.test_attr_history == ['First', 'Second']
end

run_test("Проверка strong_attr_accessor с правильным типом") do
  test.test_strong_attr = 'Valid string'
  raise "Неверное значение" unless test.test_strong_attr == 'Valid string'
end

run_test("Проверка strong_attr_accessor с неправильным типом") do
  begin
    test.test_strong_attr = 123
    raise "Удалось установить значение неправильного типа"
  rescue TypeError
    # Это ожидаемое поведение
  end
end

puts "\nТестирование модуля Validation:"

run_test("Создание правильного поезда") do
  train = Train.new('ABC-12', 'Company')
  raise "Неверный номер поезда" unless train.number == 'ABC-12'
end

run_test("Создание поезда с пустым номером") do
  begin
    Train.new('', 'Company')
    raise "Удалось создать поезд с пустым номером"
  rescue RuntimeError
    # Это ожидаемое поведение
  end
end

run_test("Создание поезда с неправильным форматом номера") do
  begin
    Train.new('123', 'Company')
    raise "Удалось создать поезд с неправильным форматом номера"
  rescue RuntimeError
    # Это ожидаемое поведение
  end
end

run_test("Создание правильной станции") do
  station = Station.new('Moscow')
  raise "Неверное имя станции" unless station.name == 'Moscow'
end

run_test("Создание станции с пустым именем") do
  begin
    Station.new('')
    raise "Удалось создать станцию с пустым именем"
  rescue RuntimeError
    # Это ожидаемое поведение
  end
end

run_test("Создание станции с неправильным форматом имени") do
  begin
    Station.new('123')
    raise "Удалось создать станцию с неправильным форматом имени"
  rescue RuntimeError
    # Это ожидаемое поведение
  end
end

run_test("Создание правильного маршрута") do
  start_station = Station.new('Start')
  end_station = Station.new('End')
  route = Route.new(start_station, end_station)
  raise "Неверные станции в маршруте" unless route.stations.map(&:name) == ['Start', 'End']
end

run_test("Создание маршрута с nil в качестве начальной станции") do
  begin
    Route.new(nil, Station.new('End'))
    raise "Удалось создать маршрут с nil в качестве начальной станции"
  rescue RuntimeError
    # Это ожидаемое поведение
  end
end

puts "\nВсе тесты завершены."
