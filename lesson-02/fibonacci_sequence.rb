#!/usr/bin/env ruby

fibonacci = [0, 1]
fibonacci << fibonacci[-2] + fibonacci[-1] while fibonacci[-1] < 100
fibonacci.pop if fibonacci.last > 100
