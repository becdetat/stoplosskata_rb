class StopLoss
	attr_reader :current_price
	attr_reader :current_time

	def initialize trail
		@trail = trail
		@current_price = 0
		@current_time = 0
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
		@current_time += ticks
		:do_nothing
	end
end



