#!/usr/bin/env ruby

# Функция для проверки високосного года
def leap_year?(year)
    (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
  end

  # Количество дней в каждом месяце
  days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  # Запрос данных у пользователя
  puts "Введите день:"
  day = gets.to_i
  puts "Введите месяц:"
  month = gets.to_i
  puts "Введите год:"
  year = gets.to_i

  # Учет високосного года
  days_in_month[1] = 29 if leap_year?(year)

  # Вычисление порядкового номера дня
  day_number = day + days_in_month.take(month - 1).sum

  puts "Порядковый номер даты: #{day_number}"
