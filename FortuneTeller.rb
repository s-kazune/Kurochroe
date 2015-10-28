class FortuneTeller
	def initialize
		@rand = Random.new
		@cardlist = File.open("./store/OneOracle.txt").readlines
		@positions = ["正位置","逆位置"]
	end

	def get_result
		res = ""
		res += @cardlist[dice(1,22,0)].chomp
		res += "の" + @positions[dice(1,2)]
	end

	def dice a=1,b=6,c=0
		ret = 0
		a.times do
			ret += rand(b)+1
		end
		ret+c
	end
end