require_relative 'Widget'
require_relative 'TableSeat'
require_relative 'Player'
require_relative 'Deck'

class Table < Widget
    MAX_SEATS = 10
    attr_accessor :seats, :bets, :deck, :dealer
    attr_accessor :turn, :bb, :ante, :pot
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
            @seats[i].labels[:bet].text = ""
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
        @dealer = nil
        @turn   = nil
        @pot    = 0
        @bb     = 20
        @ante   = 0
    end

    ## Available seats
    def availableseats
        @seats.select { |k, v| v.available? }
    end

    ## Get seats where there is a player
    def playerseats
        @seats.select { |k, v| v.player }
    end

    ## Seat a player in a seat if empty
    def seatplayer(p, seat)
        @seats[seat].player = p if @seats.key?(seat)
    end

    ## Seat a player in an empty seat
    def seatplayer_emptyseat(p)
        as = self.availableseats
        @seats[as.first[0]].player = p if as.size > 0 
    end

    ## Create players
    def createPlayers(n=1, bbrange = (18..25))
        as = self.availableseats.size
        n = as if n > as
        n.times do
            p = Player.new 
            p.stack = @bb * bbrange.to_a.sample
            seatplayer_emptyseat(p)
        end
    end

    ## Get seats where a player is seated, ordered by their preflop turn
    def playerSeats_byTurnPreflop
        if @dealer
            ps = playerseats
            if ps.size > 0
                ps = ps.keys.sort
                while ps[0] != @dealer
                    ps << ps.shift
                end
                3.times { ps << ps.shift }
            end
            ps
        end
    end

    ## Reset turn to BB
    def resetTurnToUTG
        ps = self.playerSeats_byTurnPreflop
        if ps
            @turn = ps[0]
        end
    end

    ## Pass de dealer to the next player
    def passDealer
        ## Give dealer if there is no one
        if @dealer == nil
            ps = self.playerseats 
            if ps.size > 0
                @dealer = ps.first[0]
                @seats[@dealer].dealer = true
                self.resetTurnToUTG
            end
        else
            ps = self.playerSeats_byTurnPreflop
            if ps.size > 1
                @seats[@dealer].dealer = false
                @dealer = ps[-1]
                @seats[@dealer].dealer = true
            end
            self.resetTurnToUTG
        end
    end

    ## Set new dealer
    def setNewDealer(d)
        if @seats[d].player && playerseats.size > 1
            if @dealer != nil
                @seats[@dealer].dealer = false
            end
            @dealer = d
            @seats[@dealer].dealer = true
            self.returnBetsToPlayers
            self.putBlindsAndAnte
            self.resetTurnToUTG
        end
    end

    ## Pass turn to next player in hand
    def passTurn
        if @turn
            t = @turn
            m = @seats.size 
            begin 
                m -= 1
                t = t.next
                t = @seats.first[0] if !@seats[t]
            end while m > 0 && (!@seats[t].player || @seats[t].player.status != :playing)
            @turn = t if m > 0
        end
    end

    ## Player in turn realizes an action
    def playerInTurnDoes(action)
        ## TODO: model actions
        if @turn
            case action
                when :fold then @seats[@turn].player.status = :folded
            end
            self.passTurn
        end
    end

    ## Return BETs to players
    def returnBetsToPlayers
        @seats.each do |i, k|
            if k.player
                @seats[i].returnBetToPlayer
            end
        end
    end

    ## Puts Blinds and Ante in the table
    def putBlindsAndAnte
        np = playerseats.size
        @pot = 0
        if np > 1 && @dealer
            bets = [ @bb / 2, @bb ] 
            (np-2).times { bets << @ante }
            n = @dealer
            begin
                n = n.next
                n = @seats.first[0] if !@seats[n]
                
                if @seats[n].player
                    b = bets.shift
                    @seats[n].bet b
                    @pot += b
                end
            end while n != @dealer
        end
    end

    ## Shuffle up and deal
    def dealNewHand
        self.passDealer
        self.putBlindsAndAnte

        ## Shuffle an deal
        @deck.reset
        @deck.shuffle!
        @seats.each do |i, s|
            if s.player && s.player.status != :away
                @seats[i].player.dealNewHand @deck.deal(2)
            end
        end
    end

    ## Create players
    def drawmyself
        # Background and table
        @@imgs[:table].draw 0,0,0
    end
end
