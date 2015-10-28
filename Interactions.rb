# encoding: utf-8

module Interactions
	def interaction_add_master
		puts "Kuro > who will be my master?"
		gets.chomp!
	end

	def interaction_mode_select
		loop do
			puts "Kuro > please select operation mode (1:debug, 2:practice)"
			mode = gets.chomp!
			return true if mode == "2"
			return false if mode == "1"
			puts "Kuro > incorrect input."
		end
	end
end