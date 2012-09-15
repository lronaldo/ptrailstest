require './Renderer'
require './Player'
require './Deck'

class Table
    SCR = Renderer.instance
    MAX_SEATS = 10
    attr_accessor :seats
    attr_accessor :bets, :deck
    attr_accessor :button
    attr_accessor :bb, :ante, :pot
    attr_accessor :x, :y
    attr_accessor :labels

    def initialize(seats = 6)
        self.createlabels
        self.reset(seats)
    end

    # Generate labels
    def createlabels
        # TODO: Generate depending on table
        @labels = {}
        
        # POT LABEL
        l = Label.new "POT", 6
        l.x = 26
        l.y = 9
        @labels[:pot] = l

        # POT INFO
        @labels[:potinfo] = []
        (0...3).each do |i|
            l = Label.new "info", 10
            l.x = 24
            l.y = 10 + i
            l.fg_color = COLOR_BLACK
            l.bg_color = COLOR_WHITE
            @labels[:potinfo].push l
        end

        # BET LABELS
        px = [ 32, 35, 32, 17, 14, 17 ]
        py = [  6, 11, 15, 15, 11,  6 ]
        @labels[:bets] = []
        (1..6).each do |i|
            l = Label.new "Bet Player #{i}", 9
            l.x = px[i-1]
            l.y = py[i-1]
            l.attr     = A_NORMAL
            l.fg_color = COLOR_MAGENTA
            l.bg_color = COLOR_GREEN
            @labels[:bets].push l
        end
    end

    ## Reset table
    def reset(seats = 6)
        seats = MAX_SEATS if seats > MAX_SEATS
        @seats  = {}
        @bets   = {}
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

    ## Render table
    def render(xoff = 0, yoff = 0)
        ## TODO: Consider diferent kinds of tables

        # Render table background
        x = @x + xoff
        y = @y + yoff + 3
        SCR.changeColor A_NORMAL, COLOR_BLACK, COLOR_GREEN
        (0..1).each do |i|
            (0..7).each do |j|
                j = 8-j if i == 0
                SCR.setxy x + 10 + j, y
                SCR.repchar '*', 38 - 2 * j
                y += 1
            end
        end
        SCR.setDefaultColor

        # Render labels
        @labels.each do |key, l|
            if l.is_a?(Array)
                l.each do |ll|
                    ll.render @x, @y
                end
            else
                l.render @x, @y
            end
        end
    end
end
