require_relative 'Widget'
require_relative 'Player'

class TableSeat < Widget
    ## Types of seats with respect to table position
    SEAT_TYPES = [ :d, :u, :l, :r, :ul, :ur, :dl, :dr ]
    ## Relative BET LABEL positions with respect to seat and alignments
    BL = { :r  => [ -20,  35, :r ], :l  => [ 110,  35, :l ], :d  => [ 45, -30, :c ], 
           :u  => [  45, 100, :c ], :ur => [   5,  90, :r ], :ul => [ 95,  90, :l ], 
           :dl => [  95, -20, :l ], :dr => [   5, -20, :r ] }
    ## Relative minicards positions with respect to seat and alignments

    ## CLASS ATTRIBUTES
    attr_accessor :seattype, :player, :bet
    attr_reader   :labels
    @@imgs = nil

    def initialize(window, type, x = 0, y = 0, owner = nil)
        super window, owner
        @player     = nil
        @bet        = nil
        @x          = x 
        @y          = y
        if SEAT_TYPES.include? type
            @seattype = type
        else
            @seattype = :d
        end
        loadimages
        createlabels
    end

    def loadimages
        if !@@imgs 
            @@imgs = {}
            @@imgs[:emptyseat] = Gosu::Image.new @window, "img/emptyseat.png", true 
            @@imgs[:seat]      = Gosu::Image.new @window, "img/seat.png", true 
            @@imgs[:minicard]  = Gosu::Image.new @window, "img/minicard.png", true 
        end
    end

    # Generate labels
    def createlabels
        @labels = {}

        ## Create BET LABEL
        l = Label.new self.window, "BET"
        l.x = @x + BL[@seattype][0]
        l.y = @y + BL[@seattype][1]
        case BL[@seattype][2]
            when :r then l.align = :right
            when :l then l.align = :left
        end
        l.color = 0xFFFF0000
        @labels[:bet] = l
        addChild l
    end

    ## Draw minicards if the player has non-folded cards
    def drawminicards
        
    end

    ## Create players
    def drawmyself
        # Draw seat
        if @player  
            img = :seat
        else        
            img = :emptyseat
        end
        @@imgs[img].draw @x, @y, 0
    end

    ## Seat available if no player is seated
    def available?
        @player == nil
    end
end
