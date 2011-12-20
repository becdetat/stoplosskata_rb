class StopLoss
	attr_reader :current_price
	attr_reader :time_since_last_price_change

	def initialize trail
		@trail = trail
		@current_price = 0
		@time_since_last_price_change = 0
		@delta_for_price_up = 15
	end

	def handle msg, arg
		return self.handle_price_changed(arg) if msg == :price_changed
		return self.handle_time_changed(arg) if msg == :time_changed
	end

	def handle_price_changed new_price
		@current_price = new_price if @current_price == 0
		@latest_price = new_price
		@time_since_last_price_change = 0		

		return :sell if new_price <= @current_price - @trail

		:do_nothing
	end

	def handle_time_changed ticks
		@time_since_last_price_change += ticks
		
		if @time_since_last_price_change >= @delta_for_price_up and @latest_price > @current_price then
			@current_price = @latest_price
			@time_since_last_price_change = 0
		end
		
		:do_nothing
	end
end



