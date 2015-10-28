class Dice
	def initialize
		@rand = Random.new
	end

	def dice a=1,b=6,c=0
		ret = 0
		a.times do
			ret += rand(b)+1
		end
		(ret+c).to_s
	end
end