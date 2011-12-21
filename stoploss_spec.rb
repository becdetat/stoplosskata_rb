require './stoploss.rb'

class TestConsumer
	attr_reader :received_sell
	
	def initialize
		@received_sell = false
	end
	
	def sell
		@received_sell = true
	end
end

describe StopLoss, '#handle' do
	it 'does nothing for price changed events' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is same as current price and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 10
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 15
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is same as current price and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 10
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 5
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is higher than current price and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 10
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 20
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is higher than current price and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 10
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 5
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is lower than current price but within the trail and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 4
		stoploss.handle :price_changed, 9.5
		stoploss.handle :time_changed, 20
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is lower than current price but within the trail and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 4
		stoploss.handle :price_changed, 9.5
		stoploss.handle :time_changed, 4
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when new price is equal to current price minus trail and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :price_changed, 9
		stoploss.handle :time_changed, 25		
		stoploss.consumer.received_sell.should == false
	end
	it 'triggers sell when new price is equal to current price minus trail and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :price_changed, 9
		stoploss.handle :time_changed, 30		
		stoploss.consumer.received_sell.should == true
	end
	it 'does nothing when price moves up and holds then down within threshold and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 4
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 20
		stoploss.handle :price_changed, 10.5
		stoploss.handle :time_changed, 20
		stoploss.consumer.received_sell.should == false
	end
	it 'does nothing when price moves up and holds then moves down below threshold and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 3
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 18
		stoploss.handle :price_changed, 9.5
		stoploss.handle :time_changed, 10
		stoploss.consumer.received_sell.should == false
	end
	it 'triggers sell when price moves up and holds then moves down below threshold and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 3
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 18
		stoploss.handle :price_changed, 9.5
		stoploss.handle :time_changed, 35
		stoploss.consumer.received_sell.should == true
	end
end

describe StopLoss, '#current_price' do
	it 'stays the same when the new price is the same and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 3
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 16
		stoploss.current_price.should == 10
	end
	it 'stays the same when the new price is the same and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 3
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 4
		stoploss.current_price.should == 10
	end
	it 'stays the same when the new price is lower and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 3
		stoploss.handle :price_changed, 9
		stoploss.handle :time_changed, 16
		stoploss.current_price.should == 10
	end
	it 'stays the same when the new price is lower and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 3
		stoploss.handle :price_changed, 9
		stoploss.handle :time_changed, 4
		stoploss.current_price.should == 10
	end
	it 'is increased when the new price is higher and holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :price_changed, 3
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 4
		stoploss.handle :time_changed, 6
		stoploss.handle :time_changed, 7
		stoploss.current_price.should == 11
	end
	it 'is increased when the new price is higher and does not hold' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :price_changed, 3
		stoploss.handle :price_changed, 11
		stoploss.handle :time_changed, 4
		stoploss.current_price.should == 10
	end
end

describe StopLoss, '#time_since_last_price_change' do
	it 'increases correctly' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 1
		stoploss.handle :time_changed, 3
		stoploss.handle :time_changed, 5
		stoploss.time_since_last_price_change.should == 9
	end	
	it 'resets when the price changes' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 10
		stoploss.handle :time_changed, 1
		stoploss.handle :time_changed, 3
		stoploss.handle :time_changed, 5
		stoploss.handle :price_changed, 11
		stoploss.time_since_last_price_change.should == 0
	end
	it 'resets when a price increase holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 5
		stoploss.handle :time_changed, 5
		stoploss.handle :price_changed, 7
		stoploss.handle :time_changed, 2
		stoploss.handle :time_changed, 7
		stoploss.handle :time_changed, 9
		stoploss.time_since_last_price_change.should == 0
	end
	it 'resets when a price decrease holds' do
		stoploss = StopLoss.new TestConsumer.new
		stoploss.handle :price_changed, 5
		stoploss.handle :time_changed, 1
		stoploss.handle :price_changed, 3
		stoploss.handle :time_changed, 20
		stoploss.handle :time_changed, 15
		stoploss.time_since_last_price_change.should == 0
	end
end
