class StopLoss
	attr_reader :current_price
	attr_reader :time_since_last_price_change
	attr_reader :consumer

	TRAIL = 1
	DELTA_FOR_PRICE_UP = 15
	DELTA_FOR_PRICE_DOWN = 30
	
	@current_price = nil
	@latest_price = nil
	@time_since_last_price_change = 0
	@consumer = nil
	
	def initialize consumer
		@consumer = consumer
	end

	def handle msg, arg = nil
		handle_price_changed(arg) if msg == :price_changed
		handle_time_changed(arg) if msg == :time_changed
		handle_increase_price if msg == :increase_price
		handle_decrease_price if msg == :decrease_price
	end

	def handle_price_changed new_price
		@current_price = new_price if @current_price.nil?
		@latest_price = new_price
		@time_since_last_price_change = 0
	end

	def handle_time_changed ticks
		@time_since_last_price_change += ticks
		
		handle :increase_price if current_price_should_be_increased?
		handle :decrease_price if current_price_should_be_decreased?
	end
	
	def handle_increase_price
		@current_price = @latest_price
		@time_since_last_price_change = 0
	end
	def handle_decrease_price
		@time_since_last_price_change = 0
		@consumer.sell
	end
	
	def current_price_should_be_increased?
		@time_since_last_price_change >= DELTA_FOR_PRICE_UP and @latest_price > @current_price
	end
	def current_price_should_be_decreased?
		@time_since_last_price_change >= DELTA_FOR_PRICE_DOWN and @latest_price <= @current_price - TRAIL
	end
end



