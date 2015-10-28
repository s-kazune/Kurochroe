# encoding: utf-8
require 'csv'
require 'kconv'
require 'JSON'

class TweetAnalyzer
	ParsedTwi = Struct.new(:reply, :worktype, :info)

	def initialize
		puts "Analyzer > TweetAnalyzer READY!"
		@reaction_templates = Hash.new
		CSV.foreach("./store/respond.csv", col_sep: ";") do |line|
			@reaction_templates[line[0].toutf8] = {:reply => line[1].toutf8, :type => line[2].to_sym}
		end
	end
	
	def parse(text)
		@reaction_templates.each do |input_pattern,reaction|
			#正規表現とマッチする部分全てを取り出して配列に格納．
			match_info = text.scan(/#{input_pattern}/)
			if !match_info.empty? then
				puts "Analyzer > match"
				return ParsedTwi.new(reaction[:reply].dup, reaction[:type], match_info[0]) #Stringはdupしないと書き換わってしまう
			end
		end
		nil
	end
end