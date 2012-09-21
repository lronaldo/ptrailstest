require_relative 'Widget'
require_relative 'TableSeat'
require_relative 'Player'
require_relative 'Deck'

class Table < Widget
    MAX_SEATS = 10
    attr_accessor :seats
    attr_accessor :bets, :deck
    attr_accessor :button
    attr_accessor :bb, :ante, :pot
    attr_accessor :labels
    @@imgs = nil

    def initialize(window, owner = nil, seats = 6)
        super window, owner
        self.loadimages
        self.createlabels
        self.reset(seats)
    end

    def loadimages
        if !@@imgs
            @@imgs = {}
            @@imgs[:table]  = Gosu::Image.new @window, "img/table.png", true
        end
    end

    # Generate labels
    def createlabels
        # TODO: Generate depending on table
        @labels = {}
        
        # POT LABEL
        l   = Label.new self.window, "POT"
        l.x = 395
        l.y = 140
        @labels[:pot] = l
        addChild l

        # POT INFO
        l = Label.new self.window, "pot info"
        l.x = 395
        l.y = 160
        @labels[:potinfo] = l
        addChild l
    end

    ## Reset table
    def reset(nseats = 6)
        nseats = MAX_SEATS if nseats > MAX_SEATS
        @x, @y  = 0, 0
        ## TODO: SEATS PX & PY for 2, 4, 6, 8, 9 and 10 player tables
        sx = [ 465, 645, 465, 235,  60, 235 ]
        sy = [  35, 185, 345, 345, 185,  35 ]
        st = [  :u,  :r,  :d,  :d,  :l,  :u ]
        @seats = {}
        (0...nseats).each do |i|
            @seats[i] = TableSeat.new @window, st[i], sx[i], sy[i] 
            self.addChild @seats[i]
        end
=begin
        sx = [ 465, 590, 645, 590, 465, 235, 110,  60, 110, 235 ]
        sy = [  35,  70, 185, 300, 345, 345, 300, 185,  70,  35 ]
        st = [  :u, :ur,  :r, :dr,  :d,  :d, :dl,  :l, :ul,  :u ]
        @seats = {}
        (0...10).each do |i|
            @seats[i] = TableSeat.new @window, st[i], sx[i], sy[i] 
            self.addChild @seats[i]
        end
=end
        @deck   = Deck.new @window
        @button = 0
        @pot    = 0
        @bb     = 20
        @ante   = 0
    end

    ## Available seats
    def availableseats
        @seats.select { |k, v| v.available? }
    end

    ## Seat a player in a seat if empty
    def seatplayer(p, seat)
        @seats[seat].player = p if @seats.key?(seat)
    end

    ## Seat a player in an empty seat
    def seatplayer_emptyseat(p)
        as = self.availableseats
        as[as.first[0]] = p if as.size > 0 
    end

    ## Create players
    def createplayers(n=1, bbrange = (18..25))
        as = self.availableseats.size
        n = as if n > as
        n.times do
            p = Player.new 
            p.stack = @bb * bbrange.to_a.sample
            seatplayer_emptyseat(p)
        end
    end

    ## Create players
    def drawmyself
        # Background and table
        @@imgs[:table].draw 0,0,0
    end
end
