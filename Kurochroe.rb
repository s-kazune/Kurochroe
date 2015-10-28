# encoding: utf-8
require './TwitterHandler.rb'
require './BookShelf.rb'
require './GoogleTasksHandler.rb'
require './TweetAnalyzer.rb'
require './FortuneTeller.rb'
require './interactions.rb'
require './Dice.rb'

class Kurochroe
	include Interactions

	def initialize		
		###############################################################################
		@is_practice = interaction_mode_select

		@taskman = GoogleTasksHandler.new("TODO")
		@bookman = BookShelf.new
		@chandler = TwitterHandler.new
		@analyzer = TweetAnalyzer.new
		@fortune_teller = FortuneTeller.new
		@dice = Dice.new
		
		@chandler.add_observer(self,:detect_tweet)
		@name_of_master = interaction_add_master
		@chandler.add_master(@name_of_master)

		if @is_practice then
			@chandler.connect
		else
			loop do
				twi = gets
				detect_tweet twi
			end
		end
	end

	def detect_tweet twi
		exit if twi == "STOP #kurochroe"

		request = @analyzer.parse(twi.toutf8)
		return if request.nil?

		result = handle_request(request)
		reply = make_reply(request, result)

		@chandler.post(reply) if @is_practice
	end

	def handle_request request
		puts "Kurochroe > handle #{request.worktype.to_s}"
		pp request
		case request.worktype
		when :TODO
			if request.info.length == 1 then
				@taskman.add(request.info[0])
				return request.info[0]
			elsif request.info.length == 3 then
				@taskman.add(request.info[2],request.info[0],request.info[1])
				return request.info[2]
			end
		when :BOOK
			@bookman.add(request.info[0])
		when :DICE
			#infoの中身を整数にして，引数に展開
			@dice.dice(*request.info.map(&:to_i))
		when :FTELLING
			@fortune_teller.get_result
		when :PING
			nil
		end
	end

	def make_reply request, result
		reply = request.reply
		info = request.info
		puts "Kurochroe > reply #{reply}, #{info}"
		
		#gsubにブロックを渡すと，マッチするたびにブロックの戻り値に置換する．
		reply.gsub!(/%[0-9]/) do |word|
			pp word
			pp info[word[1].to_i]
			info[word[1].to_i]
		end

		reply.gsub!(/%result%/,result) if result
		reply.gsub!(/%n/,@name_of_master)
	end
end