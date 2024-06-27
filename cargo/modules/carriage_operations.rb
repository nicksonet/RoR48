# frozen_string_literal: true

module CarriageOperations
  def add_carriage_to_train
    train = select_train
    loop do
      company_name = prompt_company_name
      carriage = create_carriage(train, company_name)
      train.add_carriage(carriage)
      print_carriage_info(train, carriage)
      break
    rescue StandardError => e
      handle_carriage_error(e)
    end
  end

  def remove_carriage_from_train
    train = select_train
    train.remove_carriage(train.carriages.last)
    puts 'Вагон отцеплен от поезда'
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
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
      puts 'Это не пассажирский поезд'
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
      puts 'Это не грузовой поезд'
    end
  end

  def show_carriage_info
    train = select_train
    if train.carriages.empty?
      puts 'У этого поезда нет вагонов'
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
end
