require './Card'

class Player
    STATUS = [ :waiting, :away, :playing, :folded ]
    attr_accessor :nick
    attr_accessor :stack
    attr_accessor :status
    attr_accessor :showcards
    attr_reader   :cards

    def initialize
        reset
    end

    def reset
        @nick       = "Player"
        @cards      = []
        @stack      = 0
        @status     = :waiting
        @showcards  = false
    end

    # Deal a card to the player
    # c should be a card
    def deal(c)
        if c.respond_to?(valid) and c.valid
            @cards << c
        end
    end
end
