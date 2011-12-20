class StopLoss
	attr_reader :current_price
	attr_reader :time_since_last_price_change

	def initialize trail
		@trail = trail
		@current_price = 0
		@time_since_last_price_change = 0
	end

	def handle msg, arg
		return self.handle_price_changed(arg) if msg == :price_changed
		return self.handle_time_changed(arg) if msg == :time_changed
	end

	def handle_price_changed new_price
		@current_price = new_price if new_price > @current_price

		return :sell if new_price <= @current_price - @trail

		:do_nothing
	end

	def handle_time_changed ticks
		@time_since_last_price_change += ticks
		:do_nothing
	end
end



