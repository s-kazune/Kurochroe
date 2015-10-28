# encoding: utf-8
require 'twitter'
require 'pp'
require 'observer'
require 'JSON'
require 'kconv'

class TwitterHandler
	include Observable

	# 初期化処理．
	########################################################################
	def initialize
		puts "Twitter > TwitterHandler READY!"
		
		#主人の初期化
		@master = Array.new

		secret_file = File.read("./auth/twitter_secret.json")
		secret = JSON.parse(secret_file)

		# 書き込み用(REST API)の準備．
		@tweet = Twitter::REST::Client.new do |config|
			config.consumer_key        = secret["ck"]
			config.consumer_secret     = secret["cs"]
			config.access_token        = secret["at"]
			config.access_token_secret = secret["as"]
		end
		puts "Twitter > rest"
		
		# 読み出し用(Stream API)
		@timeline = Twitter::Streaming::Client.new do |config|
			config.consumer_key        = secret["ck"]
			config.consumer_secret     = secret["cs"]
			config.access_token        = secret["at"]
			config.access_token_secret = secret["as"]
		end
		puts "Twitter > stream"
	end

	def add_master str
		@master << str
	end
	
	def connect
		@timeline.user do |status|
			puts "Twitter> #{status.class}"
			case status
			when Twitter::Tweet
				if @master.include?(status.attrs[:user][:screen_name]) then
					changed
					notify_observers(status.text)
				end
			end
		end
	end

	def post twi
		begin
			@tweet.update(twi) if twi
		rescue
		end
	end
end