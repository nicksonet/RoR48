# frozen_string_literal: true

module StationOperations
  def create_station
    loop do
      puts 'Введите название станции (только буквы, пробелы и дефисы, не более 30 символов):'
      puts 'Пример: Moscow Central, New York Penn, Berlin Hbf'
      name = gets.chomp
      raise 'Название станции не может быть пустым' if name.strip.empty?
      raise 'Название станции слишком длинное' if name.length > 30

      station = Station.new(name)
      @stations << station
      puts "Станция #{name} создана"
      break
    rescue StandardError => e
      puts "Ошибка при создании станции: #{e.message}"
      puts 'Пожалуйста, проверьте введенные данные и попробуйте снова.'
    end
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

  def select_station
    puts 'Выберите станцию из списка:'
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    index = gets.chomp.to_i - 1
    @stations[index]
  end

  private

  def show_carriage_info_for_train(train)
    train.each_carriage.with_index(1) do |carriage, index|
      if carriage.is_a?(PassengerCarriage)
        puts "  Вагон №#{index}: пассажирский, свободно мест: #{carriage.free_seats_count}, занято мест: #{carriage.occupied_seats_count}"
      elsif carriage.is_a?(CargoCarriage)
        puts "  Вагон №#{index}: грузовой, свободный объем: #{carriage.available_volume.round(2)}, занятый объем: #{carriage.occupied_volume.round(2)}"
      end
    end
  end
end
