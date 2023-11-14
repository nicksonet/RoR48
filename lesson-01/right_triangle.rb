#!/usr/bin/env ruby
puts "Введите сторону a:"
a = gets.chomp.to_f
puts "Введите сторону b:"
b = gets.chomp.to_f
puts "Введите сторону c:"
c = gets.chomp.to_f

sides = [a, b, c].sort
if sides[0] == sides[1] && sides[1] == sides[2]
  puts "Треугольник равносторонний и равнобедренный, но не прямоугольный"
elsif sides[2]**2 == sides[0]**2 + sides[1]**2
  puts "Треугольник прямоугольный"
  puts "Треугольник также равнобедренный" if sides[0] == sides[1] || sides[1] == sides[2]
else
  puts "Треугольник не является прямоугольным"
end
