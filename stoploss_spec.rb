require './stoploss.rb'

describe StopLoss, '#handle' do
	it 'does nothing for empty message' do
		stoploss = StopLoss.new
		action = stoploss.handle PriceChangedMessage.new
		action.should == :do_nothing
	end
end
