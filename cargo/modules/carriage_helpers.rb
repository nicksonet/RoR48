# frozen_string_literal: true

module CarriageHelpers
  private

  def prompt_company_name
    puts 'Введите название компании вагона (только буквы, пробелы, дефисы и апострофы, не более 30 символов):'
    puts 'Пример: Siemens, Bombardier, Alstom'
    company_name = gets.chomp
    raise 'Название компании не может быть пустым' if company_name.strip.empty?

    company_name
  end

  def create_carriage(train, company_name)
    if train.is_a?(PassengerTrain)
      create_passenger_carriage(company_name)
    else
      create_cargo_carriage(company_name)
    end
  end

  def create_passenger_carriage(company_name)
    puts 'Введите количество мест в вагоне (целое число больше 0):'
    total_seats = gets.chomp.to_i
    raise 'Количество мест должно быть положительным числом' if total_seats <= 0

    PassengerCarriage.new(company_name, total_seats)
  end

  def create_cargo_carriage(company_name)
    puts 'Введите общий объем грузового вагона (положительное число):'
    total_volume = gets.chomp.to_f
    raise 'Объем должен быть положительным числом' if total_volume <= 0

    CargoCarriage.new(company_name, total_volume)
  end

  def print_carriage_info(train, carriage)
    puts "Вагон добавлен к поезду, компания: #{carriage.company_name}"
    if train.is_a?(PassengerTrain)
      puts "Общее количество мест: #{carriage.total_seats}"
    else
      puts "Общий объем: #{carriage.total_volume}"
    end
  end

  def handle_carriage_error(error)
    puts "Ошибка при добавлении вагона: #{error.message}"
    puts 'Пожалуйста, проверьте введенные данные и попробуйте снова.'
  end

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
