require_relative 'Widget'
require_relative 'Player'

class TableSeat < Widget
    ## Types of seats with respect to table position
    SEAT_TYPES = [ :d, :u, :l, :r, :ul, :ur, :dl, :dr ]
    ## Relative BET LABEL positions with respect to seat and alignments
    DX = { :r  => -20, :l  => 110, :d  =>  45, :u  =>  45, 
           :ur =>   5, :ul =>  95, :dl =>  95, :dr =>   5 }
    DY = { :r  =>  35, :l  =>  35, :d  => -30, :u  => 100, 
           :ur =>  90, :ul =>  90, :dl => -20, :dr => -20 }
    DA = { :r  => :right, :l  => :left,  :d  => :center, 
           :u  => :center,:ur => :right, :ul => :left, 
           :dl => :left,  :dr => :right }

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

        ## BET LABEL

        ## Create BET LABEL
        l = Label.new self.window, "BET"
        l.x = @x + DX[@seattype]
        l.y = @y + DY[@seattype]
        l.align =  DA[@seattype]
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
