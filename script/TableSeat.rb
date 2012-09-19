require_relative 'Widget'
require_relative 'Player'

class TableSeat < Widget
    ## Types of seats with respect to table position
    SEAT_TYPES = [ :d, :u, :l, :r, :ul, :ur, :dl, :dr ]
    ## Relative BET LABEL positions with respect to seat and alignments
    BL = { :r  => [ -30,  35, :r ], :l  => [ 120,  35, :l ], :d  => [  45, -45, :c ], 
           :u  => [  45, 125, :c ], :ur => [   5, 100, :r ], :ul => [ 105, 100, :l ], 
           :dl => [ 105, -25, :l ], :dr => [  -5, -25, :r ] }
    ## Relative minicards positions with respect to seat and alignments
    MC = { :r  => [ -20,  30 ], :l  => [  85,  30 ], :d  => [ 35, -25 ], 
           :u  => [  35,  80 ], :ur => [  10,  75 ], :ul => [ 75,  70 ], 
           :dl => [  75, -10 ], :dr => [   0, -15 ] }

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
        if true #s.player && s.player.status == :playing
            d = MC[@seattype]
            @@imgs[:minicard].draw @x + d[0], @y + d[1], 0
            @@imgs[:minicard].draw @x + d[0] + 5, @y + d[1] + 5, 0
        end
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

        ## Draw minicards
        drawminicards
    end

    ## Seat available if no player is seated
    def available?
        @player == nil
    end
end
