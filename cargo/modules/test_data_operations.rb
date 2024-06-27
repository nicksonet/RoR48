# frozen_string_literal: true

module TestDataOperations
  def create_test_data_and_show_info
    stations = create_test_stations
    trains = create_test_trains
    add_carriages_to_trains(trains)
    place_trains_on_stations(stations, trains)
    occupy_seats_and_volume(trains)
    display_station_info(Station.all)
  end

  private

  def create_test_stations
    ['Moscow', 'Saint Petersburg', 'Kazan'].map { |name| Station.new(name) }
  end

  def create_test_trains
    [
      PassengerTrain.new('PAX-01', 'Russian Railways'),
      CargoTrain.new('CARGO-01', 'RZD Logistics'),
    ]
  end

  def add_carriages_to_trains(trains)
    trains.each do |train|
      3.times do
        carriage = if train.is_a?(PassengerTrain)
                     PassengerCarriage.new('Siemens', 54)
                   else
                     CargoCarriage.new('UWC', 138.0)
                   end
        train.add_carriage(carriage)
      end
    end
  end

  def place_trains_on_stations(stations, trains)
    stations[0].add_train(trains[0])
    stations[1].add_train(trains[1])
  end

  def occupy_seats_and_volume(trains)
    trains[0].each_carriage.with_index do |carriage, i|
      (i + 1) * 10.times { carriage.take_seat }
    end

    trains[1].each_carriage.with_index do |carriage, i|
      carriage.occupy_volume((i + 1) * 40.0)
    end
  end

  def display_station_info(stations)
    stations.each do |station|
      puts "Станция: #{station.name}"
      if station.trains.empty?
        puts '  На станции нет поездов'
      else
        display_station_trains(station)
      end
      puts
    end
  end

  def display_station_trains(station)
    station.each_train do |train|
      puts "  Поезд №#{train.number}, тип: #{train.class.name.gsub('Train', '')}, вагонов: #{train.carriages.size}"
      display_train_carriages(train)
    end
  end

  def display_train_carriages(train)
    train.each_carriage.with_index(1) do |carriage, index|
      if carriage.is_a?(PassengerCarriage)
        puts "    Вагон №#{index}: пассажирский, свободно мест: #{carriage.free_seats_count}, занято мест: #{carriage.occupied_seats_count}"
      elsif carriage.is_a?(CargoCarriage)
        puts "    Вагон №#{index}: грузовой, свободный объем: #{carriage.available_volume.round(2)}, занятый объем: #{carriage.occupied_volume.round(2)}"
      end
    end
  end
end
