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

    def initialize(seats = 6)
        reset(seats)
    end

    ## Reset table
    def reset(seats)
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
    def render
        ## TODO: Consider diferent kinds of tables

        # Render table background
        y = @y + 3
        SCR.changeColor A_NORMAL, COLOR_GREEN, COLOR_GREEN
        (0..1).each do |i|
            (0..8).each do |j|
                j = 8-j if i == 0
                SCR.setxy @x + 10 + j, y
                SCR.repchar '*', 38 - 2 * j
                y += 1
            end
        end
        SCR.setDefaultColor

        # Render Pot
        
    end
end
