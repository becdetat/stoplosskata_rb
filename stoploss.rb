class PriceChangedMessage
	attr_reader :new_price

	def initialize new_price
		@new_price = new_price
	end
end

class StopLoss
	attr_reader :current_price

	def initialize trail
		@trail = trail
		@current_price = 0
	end

	def handle msg
		@current_price = msg.new_price if msg.new_price > @current_price

		return :sell if msg.new_price <= @current_price - @trail

		:do_nothing
	end
end



