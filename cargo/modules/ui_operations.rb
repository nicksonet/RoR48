# frozen_string_literal: true

module UIOperations
  def print_menu
    puts 'Выберите действие:'
    puts '1. Создать станцию'
    puts '2. Создать поезд'
    puts '3. Создать маршрут'
    puts '4. Добавить станцию в маршрут'
    puts '5. Удалить станцию из маршрута'
    puts '6. Назначить маршрут поезду'
    puts '7. Добавить вагон к поезду'
    puts '8. Отцепить вагон от поезда'
    puts '9. Переместить поезд вперед по маршруту'
    puts '10. Переместить поезд назад по маршруту'
    puts '11. Просмотреть список станций и список поездов на станции'
    puts '12. Найти поезд по номеру'
    puts '13. Показать список вагонов у поезда'
    puts '14. Занять место в пассажирском вагоне'
    puts '15. Занять объем в грузовом вагоне'
    puts '16. Показать информацию о поездах на станции'
    puts '17. Создать тестовые данные и показать информацию'
    puts '0. Выйти'
  end

  def user_input
    gets.chomp
  end

  def print_error(message)
    puts "Ошибка: #{message}"
  end

  def print_success(message)
    puts "Успешно: #{message}"
  end

  def print_info(message)
    puts message
  end
end
