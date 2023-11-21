#!/usr/bin/env ruby

vowels = 'aeiou'
vowels_hash = {}
vowels.each_char.with_index(1) { |vowel, index| vowels_hash[vowel] = index }
