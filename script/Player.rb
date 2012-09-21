require_relative 'Card'

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
        if c.respond_to?(:valid) and c.valid
            @cards << c
        end
    end

    def dealHand(vec)
        vec.each { |c| self.deal(c) }
        @status = :playing
    end

    def status=(st)
       @status = st if STATUS.include?(st) 
    end 
end
