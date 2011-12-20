See https://gist.github.com/1500720

I am *not* a skilled Ruby programmer, in fact this is the first time I've tried TDD in Ruby apart from the koans? So. Just messing around ;-)

I'm using RSpec, `gem install rspec` then `rspec stoploss_spec.rb` to see my pitiful attempt probably fail.

Well I think I covered Greg's spec (using the [hint to treat time as a message][1]), but there was still a grey area for me. The sell point moves up and stop losses are triggered if the price is _held_ over a threshold but what if the price is shifting within the threshold? The price isn't holding, so the timer gets reset and it doesn't move the sell point or trigger the sell order. Anyway too much for me at the moment.

The kata could probably be expanded by changing price change events to external sells and purchases, which then gives the volume so you can volume- and time-weight the market movements and make the stop-loss event more accurate. Then add in a 'buy more' event, hook it up to a trading system and give it $10000. Now _there's_ a kata.


[1]: https://gist.github.com/1500722