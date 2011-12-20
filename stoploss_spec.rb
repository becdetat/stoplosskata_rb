require './stoploss.rb'

describe StopLoss, '#handle' do
	it 'does nothing when new price is same as current price' do
		stoploss = StopLoss.new 1, 10
		action = stoploss.handle PriceChangedMessage.new 10
		action.should == :do_nothing
	end
end

describe StopLoss, '#get_current_price' do
	it 'stays the same when the new price is the same' do
		stoploss = StopLoss.new 1, 10
		stoploss.handle PriceChangedMessage.new 10
		stoploss.current_price.should == 10
	end
	it 'stays the same when the new price is lower' do
		stoploss = StopLoss.new 1, 10
		stoploss.handle PriceChangedMessage.new 9
		stoploss.current_price.should == 10
	end
	it 'is increased when the new price is higher' do
		stoploss = StopLoss.new 1, 10
		stoploss.handle PriceChangedMessage.new 11
		stoploss.current_price.should == 11
	end
end
