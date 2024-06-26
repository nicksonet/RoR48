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
      when 12 then find_train
      when 13 then show_carriage_info
      when 14 then take_seat_in_carriage
      when 15 then occupy_volume_in_carriage
      when 16 then show_trains_on_station
      when 17 then create_test_data_and_show_info
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
    puts "12. Найти поезд по номеру"
    puts "13. Показать список вагонов у поезда"
    puts "14. Занять место в пассажирском вагоне"
    puts "15. Занять объем в грузовом вагоне"
    puts "16. Показать информацию о поездах на станции"
    puts "17. Создать тестовые данные и показать информацию"
    puts "0. Выйти"
  end

  def create_station
    loop do
      begin
        puts "Введите название станции (только буквы, пробелы и дефисы, не более 30 символов):"
        puts "Пример: Moscow Central, New York Penn, Berlin Hbf"
        name = gets.chomp
        raise "Название станции не может быть пустым" if name.strip.empty?
        raise "Название станции слишком длинное" if name.length > 30
        station = Station.new(name)
        @stations << station
        puts "Станция #{name} создана"
        break
      rescue StandardError => e
        puts "Ошибка при создании станции: #{e.message}"
        puts "Пожалуйста, проверьте введенные данные и попробуйте снова."
      end
    end
  end

  def create_train
    puts "Выберите тип поезда:"
    puts "1. Пассажирский"
    puts "2. Грузовой"
    type = gets.chomp.to_i

    loop do
      begin
        puts "Введите номер поезда (формат: три буквы или цифры, необязательный дефис, еще 2 буквы или цифры):"
        puts "Пример: ABC-12 или 123-DE или AAA11"
        number = gets.chomp
        raise "Номер поезда не может быть пустым" if number.strip.empty?

        puts "Введите название компании (только буквы, пробелы, дефисы и апострофы, не более 30 символов):"
        puts "Пример: Russian Railways, Amtrak, DB"
        company_name = gets.chomp
        raise "Название компании не может быть пустым" if company_name.strip.empty?

        train = case type
                when 1
                  PassengerTrain.new(number, company_name)
                when 2
                  CargoTrain.new(number, company_name)
                else
                  raise "Неверный тип поезда"
                end

        @trains << train
        puts "#{train.class} поезд #{train.number} создан, компания: #{train.company_name}"
        break
      rescue StandardError => e
        puts "Ошибка при создании поезда: #{e.message}"
        puts "Пожалуйста, проверьте введенные данные и попробуйте снова."
      end
    end
  end

  def create_route
    puts "Выберите начальную станцию маршрута:"
    start_station = select_station
    puts "Выберите конечную станцию маршрута:"
    end_station = select_station
    route = Route.new(start_station, end_station)
    @routes << route
    puts "Маршрут создан"
  rescue StandardError => e
    puts "Ошибка при создании маршрута: #{e.message}"
    retry
  end

  def add_station_to_route
    route = select_route
    station = select_station
    route.add_station(station)
    puts "Станция добавлена в маршрут"
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def remove_station_from_route
    route = select_route
    station = select_station
    route.remove_station(station)
    puts "Станция удалена из маршрута"
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def assign_route_to_train
    train = select_train
    route = select_route
    train.assign_route(route)
    puts "Маршрут назначен поезду"
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def add_carriage_to_train
    train = select_train
    loop do
      begin
        puts "Введите название компании вагона (только буквы, пробелы, дефисы и апострофы, не более 30 символов):"
        puts "Пример: Siemens, Bombardier, Alstom"
        company_name = gets.chomp
        raise "Название компании не может быть пустым" if company_name.strip.empty?

        if train.is_a?(PassengerTrain)
          puts "Введите количество мест в вагоне (целое число больше 0):"
          total_seats = gets.chomp.to_i
          raise "Количество мест должно быть положительным числом" if total_seats <= 0
          carriage = PassengerCarriage.new(company_name, total_seats)
        else
          puts "Введите общий объем грузового вагона (положительное число):"
          total_volume = gets.chomp.to_f
          raise "Объем должен быть положительным числом" if total_volume <= 0
          carriage = CargoCarriage.new(company_name, total_volume)
        end

        train.add_carriage(carriage)
        puts "Вагон добавлен к поезду, компания: #{company_name}"
        if train.is_a?(PassengerTrain)
          puts "Общее количество мест: #{total_seats}"
        else
          puts "Общий объем: #{total_volume}"
        end
        break
      rescue StandardError => e
        puts "Ошибка при добавлении вагона: #{e.message}"
        puts "Пожалуйста, проверьте введенные данные и попробуйте снова."
      end
    end
  end

  def take_seat_in_carriage
    train = select_train
    if train.is_a?(PassengerTrain)
      carriage = select_carriage(train)
      if carriage
        begin
          carriage.take_seat
          puts "Место успешно занято. Занято мест: #{carriage.occupied_seats_count}, свободно мест: #{carriage.free_seats_count}"
        rescue StandardError => e
          puts "Ошибка при занятии места: #{e.message}"
        end
      end
    else
      puts "Это не пассажирский поезд"
    end
  end

  def show_carriage_info
    train = select_train
    if train.carriages.empty?
      puts "У этого поезда нет вагонов"
    else
      puts "Список вагонов поезда №#{train.number}:"
      train.each_carriage.with_index(1) do |carriage, index|
        if carriage.is_a?(PassengerCarriage)
          puts "  Вагон №#{index}: пассажирский, компания: #{carriage.company_name}"
          puts "    Всего мест: #{carriage.total_seats}, свободно: #{carriage.free_seats_count}, занято: #{carriage.occupied_seats_count}"
        elsif carriage.is_a?(CargoCarriage)
          puts "  Вагон №#{index}: грузовой, компания: #{carriage.company_name}"
          puts "    Общий объем: #{carriage.total_volume}, свободно: #{carriage.available_volume.round(2)}, занято: #{carriage.occupied_volume.round(2)}"
        end
      end
    end
  end

  def occupy_volume_in_carriage
    train = select_train
    if train.is_a?(CargoTrain)
      carriage = select_carriage(train)
      if carriage
        begin
          puts "Введите объем, который хотите занять (доступно: #{carriage.available_volume.round(2)}):"
          volume = gets.chomp.to_f
          carriage.occupy_volume(volume)
          puts "Объем успешно занят. Занятый объем: #{carriage.occupied_volume.round(2)}, доступный объем: #{carriage.available_volume.round(2)}"
        rescue StandardError => e
          puts "Ошибка при занятии объема: #{e.message}"
        end
      end
    else
      puts "Это не грузовой поезд"
    end
  end

  def show_trains_on_station
    station = select_station
    if station.trains.empty?
      puts "На станции #{station.name} нет поездов"
    else
      puts "Список поездов на станции #{station.name}:"
      station.each_train do |train|
        puts "Поезд №#{train.number}, тип: #{train.class.name.gsub('Train', '')}, вагонов: #{train.carriages.size}"
        show_carriage_info_for_train(train)
      end
    end
  end

  def show_carriage_info_for_train(train)
    train.each_carriage.with_index(1) do |carriage, index|
      if carriage.is_a?(PassengerCarriage)
        puts "  Вагон №#{index}: пассажирский, свободно мест: #{carriage.free_seats_count}, занято мест: #{carriage.occupied_seats_count}"
      elsif carriage.is_a?(CargoCarriage)
        puts "  Вагон №#{index}: грузовой, свободный объем: #{carriage.available_volume.round(2)}, занятый объем: #{carriage.occupied_volume.round(2)}"
      end
    end
  end

  def create_test_data_and_show_info
    # Создаем станции
    station1 = Station.new("Moscow")
    station2 = Station.new("Saint Petersburg")
    station3 = Station.new("Kazan")

    # Создаем поезда
    train1 = PassengerTrain.new("PAX-01", "Russian Railways")
    train2 = CargoTrain.new("CARGO-01", "RZD Logistics")

    # Создаем вагоны и добавляем их к поездам
    3.times do |i|
      train1.add_carriage(PassengerCarriage.new("Siemens", 54))
      train2.add_carriage(CargoCarriage.new("UWC", 138.0))
    end

    # Размещаем поезда на станциях
    station1.add_train(train1)
    station2.add_train(train2)

    # Занимаем места и объемы в вагонах
    train1.each_carriage.with_index do |carriage, i|
      (i + 1) * 10.times { carriage.take_seat }
    end

    train2.each_carriage.with_index do |carriage, i|
      carriage.occupy_volume((i + 1) * 40.0)
    end

    # Выводим информацию о станциях, поездах и вагонах
    [station1, station2, station3].each do |station|
      puts "Станция: #{station.name}"
      if station.trains.empty?
        puts "  На станции нет поездов"
      else
        station.each_train do |train|
          puts "  Поезд №#{train.number}, тип: #{train.class.name.gsub('Train', '')}, вагонов: #{train.carriages.size}"
          train.each_carriage.with_index(1) do |carriage, index|
            if carriage.is_a?(PassengerCarriage)
              puts "    Вагон №#{index}: пассажирский, свободно мест: #{carriage.free_seats_count}, занято мест: #{carriage.occupied_seats_count}"
            elsif carriage.is_a?(CargoCarriage)
              puts "    Вагон №#{index}: грузовой, свободный объем: #{carriage.available_volume.round(2)}, занятый объем: #{carriage.occupied_volume.round(2)}"
            end
          end
        end
      end
      puts
    end
  end

  private

  def select_carriage(train)
    if train.carriages.empty?
      puts "У этого поезда нет вагонов"
      return nil
    end

    puts "Выберите номер вагона:"
    train.carriages.each_with_index do |carriage, index|
      puts "#{index + 1}. Вагон компании #{carriage.company_name}"
      if carriage.is_a?(PassengerCarriage)
        puts "   Свободные места: #{carriage.free_seats_count} (номера мест: #{(carriage.occupied_seats_count + 1..carriage.total_seats).to_a.join(', ')})"
        puts "   Занятые места: #{carriage.occupied_seats_count} (номера мест: #{(1..carriage.occupied_seats_count).to_a.join(', ')})"
      elsif carriage.is_a?(CargoCarriage)
        puts "   Доступный объем: #{carriage.available_volume}"
        puts "   Занятый объем: #{carriage.occupied_volume}"
      end
    end

    choice = gets.chomp.to_i
    if choice > 0 && choice <= train.carriages.size
      train.carriages[choice - 1]
    else
      puts "Неверный выбор вагона"
      nil
    end
  end

  def remove_carriage_from_train
    train = select_train
    train.remove_carriage(train.carriages.last)
    puts "Вагон отцеплен от поезда"
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def move_train_forward
    train = select_train
    train.move_forward
    puts "Поезд перемещен вперед"
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def move_train_backward
    train = select_train
    train.move_backward
    puts "Поезд перемещен назад"
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def list_stations_and_trains
    @stations.each do |station|
      puts "Станция: #{station.name}"
      station.trains.each do |train|
        puts "  Поезд #{train.number}, тип: #{train.class}, вагонов: #{train.carriages.size}, компания: #{train.company_name}"
        train.carriages.each_with_index do |carriage, index|
          puts "    Вагон №#{index + 1}, компания: #{carriage.company_name}"
        end
      end
    end
  end

  def set_company_name
    puts "Установить название компании для:"
    puts "1. Поезда"
    puts "2. Вагона"
    choice = gets.chomp.to_i
    case choice
    when 1
      train = select_train
      puts "Введите название компании для поезда #{train.number}:"
      company_name = gets.chomp
      train.company_name = company_name
      puts "Компания для поезда #{train.number} установлена как #{company_name}"
    when 2
      train = select_train
      puts "Выберите вагон:"
      train.carriages.each_with_index do |carriage, index|
        puts "#{index + 1}. Вагон #{index + 1}, компания: #{carriage.company_name}"
      end
      carriage_index = gets.chomp.to_i - 1
      carriage = train.carriages[carriage_index]
      puts "Введите название компании для вагона #{carriage_index + 1}:"
      company_name = gets.chomp
      carriage.company_name = company_name
      puts "Компания для вагона #{carriage_index + 1} установлена как #{company_name}"
    else
      puts "Неверный выбор"
    end
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def find_train
    puts "Введите номер поезда:"
    number = gets.chomp
    train = Train.find(number)
    if train
      puts "Поезд #{train.number}, тип: #{train.class}, компания: #{train.company_name}"
    else
      puts "Поезд с номером #{number} не найден"
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
