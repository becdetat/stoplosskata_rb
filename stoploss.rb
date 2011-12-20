class PriceChangedMessage
end

class StopLoss
	def HandleMessage msg
		puts 'Received a message'
	end
end



stopLoss = StopLoss.new
stopLoss.HandleMessage PriceChangedMessage.new
stopLoss.HandleMessage PriceChangedMessage.new

