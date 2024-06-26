# frozen_string_literal: true

module TrainOperations
  def create_train
    puts 'Выберите тип поезда:'
    puts '1. Пассажирский'
    puts '2. Грузовой'
    type = gets.chomp.to_i

    loop do
      puts 'Введите номер поезда (формат: три буквы или цифры, необязательный дефис, еще 2 буквы или цифры):'
      puts 'Пример: ABC-12 или 123-DE или AAA11'
      number = gets.chomp
      raise 'Номер поезда не может быть пустым' if number.strip.empty?

      puts 'Введите название компании (только буквы, пробелы, дефисы и апострофы, не более 30 символов):'
      puts 'Пример: Russian Railways, Amtrak, DB'
      company_name = gets.chomp
      raise 'Название компании не может быть пустым' if company_name.strip.empty?

      train = case type
              when 1
                PassengerTrain.new(number, company_name)
              when 2
                CargoTrain.new(number, company_name)
              else
                raise 'Неверный тип поезда'
              end

      @trains << train
      puts "#{train.class} поезд #{train.number} создан, компания: #{train.company_name}"
      break
    rescue StandardError => e
      puts "Ошибка при создании поезда: #{e.message}"
      puts 'Пожалуйста, проверьте введенные данные и попробуйте снова.'
    end
  end

  def move_train_forward
    train = select_train
    train.move_forward
    puts 'Поезд перемещен вперед'
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def move_train_backward
    train = select_train
    train.move_backward
    puts 'Поезд перемещен назад'
  rescue StandardError => e
    puts "Ошибка: #{e.message}. Попробуйте снова."
    retry
  end

  def find_train
    puts 'Введите номер поезда:'
    number = gets.chomp
    train = Train.find(number)
    if train
      puts "Поезд #{train.number}, тип: #{train.class}, компания: #{train.company_name}"
    else
      puts "Поезд с номером #{number} не найден"
    end
  end

  def select_train
    puts 'Выберите поезд из списка:'
    @trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" }
    index = gets.chomp.to_i - 1
    @trains[index]
  end
end
