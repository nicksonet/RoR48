# frozen_string_literal: true

module CarriageOperations
  def add_carriage_to_train
    train = select_train
    loop do
      puts 'Введите название компании вагона (только буквы, пробелы, дефисы и апострофы, не более 30 символов):'
      puts 'Пример: Siemens, Bombardier, Alstom'
      company_name = gets.chomp
      raise 'Название компании не может быть пустым' if company_name.strip.empty?

      if train.is_a?(PassengerTrain)
        puts 'Введите количество мест в вагоне (целое число больше 0):'
        total_seats = gets.chomp.to_i
        raise 'Количество мест должно быть положительным числом' if total_seats <= 0

        carriage = PassengerCarriage.new(company_name, total_seats)
      else
        puts 'Введите общий объем грузового вагона (положительное число):'
        total_volume = gets.chomp.to_f
        raise 'Объем должен быть положительным числом' if total_volume <= 0

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
      puts 'Пожалуйста, проверьте введенные данные и попробуйте снова.'
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

  private

  def select_carriage(train)
    if train.carriages.empty?
      puts 'У этого поезда нет вагонов'
      return nil
    end

    puts 'Выберите номер вагона:'
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
    if choice.positive? && choice <= train.carriages.size
      train.carriages[choice - 1]
    else
      puts 'Неверный выбор вагона'
      nil
    end
  end
end
