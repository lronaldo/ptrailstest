require './Card'

class Deck
    attr_reader :cards

    def initialize
        self.reset
    end
    
    # Create a vector with all the cards
    def reset
        @cards = []
        c = Card.new
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
