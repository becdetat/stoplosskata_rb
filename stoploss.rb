class PriceChangedMessage
	attr_reader :new_price

	def initialize new_price
		@new_price = new_price
	end
end
class TimeChangedMessage
	attr_reader :ticks

	def initialize ticks
		@ticks = ticks
	end
end

class StopLoss
	attr_reader :current_price
	attr_reader :current_time

	def initialize trail
		@trail = trail
		@current_price = 0
		@current_time = 0
	end

	def handle msg
		return self.handle_price_changed(msg) if msg.respond_to? 'new_price'
		return self.handle_time_changed(msg) if msg.respond_to? 'ticks'
	end

	def handle_price_changed msg
		@current_price = msg.new_price if msg.new_price > @current_price

		return :sell if msg.new_price <= @current_price - @trail

		:do_nothing
	end

	def handle_time_changed msg
		@current_time += msg.ticks
		:do_nothing
	end
end



