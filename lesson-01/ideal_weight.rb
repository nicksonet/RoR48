#!/usr/bin/env ruby
puts "Введите ваше имя:"
name = gets.chomp
puts "Введите ваш рост:"
height = gets.chomp.to_i

ideal_weight = (height - 110) * 1.15
if ideal_weight < 0
  puts "#{name}, ваш вес уже оптимальный"
else
  puts "#{name}, ваш идеальный вес: #{ideal_weight.round(2)} кг"
end
