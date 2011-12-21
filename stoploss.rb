class StopLoss
	attr_reader :current_price
	attr_reader :time_since_last_price_change

	TRAIL = 1
	DELTA_FOR_PRICE_UP = 15
	DELTA_FOR_PRICE_DOWN = 30
	
	@current_price = nil
	@latest_price = nil
	@time_since_last_price_change = 0
	
	def initialize 
	end

	def handle msg, arg
		return self.handle_price_changed(arg) if msg == :price_changed
		return self.handle_time_changed(arg) if msg == :time_changed
	end

	def handle_price_changed new_price
		@current_price = new_price if @current_price.nil?
		@latest_price = new_price
		@time_since_last_price_change = 0		

		:do_nothing
	end

	def handle_time_changed ticks
		@time_since_last_price_change += ticks
		
		if @time_since_last_price_change >= DELTA_FOR_PRICE_UP and @latest_price > @current_price then
			@current_price = @latest_price
			@time_since_last_price_change = 0
			return :do_nothing
		end
		
		if @time_since_last_price_change >= DELTA_FOR_PRICE_DOWN and @latest_price <= @current_price - TRAIL then
			@time_since_last_price_change = 0
			return :sell
		end
		
		:do_nothing
	end
end



