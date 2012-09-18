require_relative 'Widget'
require_relative 'Player'
require_relative 'Deck'

class Table < Widget
    MAX_SEATS = 10
    attr_accessor :seats
    attr_accessor :bets, :deck
    attr_accessor :button
    attr_accessor :bb, :ante, :pot
    attr_accessor :labels

    def initialize(window, owner = nil, seats = 6)
        super window, owner
        @img_table     = Gosu::Image.new @window, "img/table.png", true
        @img_emptyseat = Gosu::Image.new @window, "img/emptyseat.png", true 
        @img_seat      = Gosu::Image.new @window, "img/seat.png", true 
        self.createlabels
        self.reset(seats)
    end

    # Generate labels
    def createlabels
        # TODO: Generate depending on table
        @labels = {}
        
        # POT LABEL
        l   = Label.new self.window, "POT"
        l.x = 395
        l.y = 200
        @labels[:pot] = l
        addChild l

        # POT INFO
        l = Label.new self.window, "pot info"
        l.x = 395
        l.y = 220
        @labels[:potinfo] = l
        addChild l

        # BET LABELS
        px = [ 510, 625, 510, 280, 175, 280 ]
        py = [ 140, 220, 310, 310, 220, 140 ]
        al = [  :c,  :r,  :c,  :c,  :l,  :c ]
        @labels[:bets] = []
        (1..6).each do |i|
            l = Label.new self.window, "BP #{i}"
            l.x = px[i-1]
            l.y = py[i-1]
            l.color = 0xFFFF0000
            case al[i-1]
                when :r then l.align = :right
                when :l then l.align = :left
            end
            @labels[:bets].push l
            addChild l
        end
    end

    ## Reset table
    def reset(seats = 6)
        seats = MAX_SEATS if seats > MAX_SEATS
        ## TODO: SEATS PX & PY for 2, 4, 6, 8, 9 and 10 player tables
        @seats_px = [ 465, 630, 465, 235,  75, 235 ]
        @seats_py = [  50, 185, 330, 330, 185,  50 ]
        @seats    = {}
        @bets     = {}
        (0...seats).each do |i|
            @seats[i] = nil
            @bets[i]  = nil
        end
        @deck   = Deck.new
        @button = 0
        @pot    = 0
        @bb     = 20
        @ante   = 0
        @x, @y  = 0, 0
    end

    ## Available seats
    def availableseats
        @seats.select { |k, v| v == nil }
    end

    ## Seat a player in a seat if empty
    def seatplayer(p, seat)
        @seats[seat] = p if @seats.key?(seat)
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
        @img_table.draw 0,0,0

        # Seats
        @seats.each do |i, s|
            if s
                img = @img_seat
            else
                img = @img_emptyseat
            end
            img.draw @seats_px[i], @seats_py[i], 0
        end
    end
end
