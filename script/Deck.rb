require_relative 'Card'
require_relative 'Widget'

class Deck < Widget
    attr_reader :cards

    def initialize(window, owner = nil)
        super window, owner
        self.reset
    end
    
    # Create a vector with all the cards
    def reset
        @cards = []
        c = Card.new @window
        while c.value
            @cards << c.clone
            c.next!
        end
    end

    def shuffle!
        @cards.shuffle!
        self
    end

    def deal(n = 1)
        @cards.shift(n)
    end
end
