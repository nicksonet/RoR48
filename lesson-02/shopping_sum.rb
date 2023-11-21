#!/usr/bin/env ruby

purchases = {}
loop do
  puts 'Введите название товара (или "стоп" для завершения):'
  product = gets.chomp
  break if product == 'стоп'

  puts 'Введите цену за единицу:'
  price = gets.chomp.to_f

  puts 'Введите количество товара:'
  quantity = gets.chomp.to_f

  purchases[product] = { price: price, quantity: quantity }
end

total_sum = 0
purchases.each do |product, info|
  sum = info[:price] * info[:quantity]
  puts "#{product}: #{sum}"
  total_sum += sum
end

puts "Итоговая сумма: #{total_sum}"
