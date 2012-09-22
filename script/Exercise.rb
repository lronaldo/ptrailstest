require_relative 'Table'
require_relative 'CardRange'

class Exercise < Widget
=begin
    EP50 = { ep: CardRange.new("55+ ATo+ A9s+ KJo+ KTs+ QJo+ QTs+ JTs  T9s"),
             mp: CardRange.new("22+ A9o+ A7s+ KTo+ K9s+ QTo+ Q9s+ JTo  J9s+ T9s  98s  87s"),
             co_des: CardRange.new("22+ A8o+ A2s+ KTo+ K8s+ QTo+ Q9s+ JTo  J9s+ T9s  98s  87s"),
             co_fav: CardRange.new("22+ A2+  K8o+ K5s+ Q9o+ Q8s+ J9o+ J8s+ T9o  T8s+ 97s+ 86s+ 76s 65s 54s")
       }   
=end

    DEALER_POS = { d: 3, sb: 2, bb: 1, ep: 0, mp: 5, co: 4 }
    RANGOS_OR_7 = {
        inicial: {
            ep: "66+ ATs+ AJo+ KQs",
            mp: "66+ ATs+ AJo+ KQs",
            co: "66+ ATs+ AJo+ KQs",
            d:  "22+ A2+ K9s+ KTo+ Q9s+ QTo+ J9s+ JTo T9s",
            sb: "22+ A2+ K9s+ KTo+ Q9s+ QTo+ J9s+ JTo T9s"
        },
        media: {
            ep: "66+ ATs+ AJo+ KQs",
            mp: "66+ ATs+ AJo+ KQs",
            co: "66+ ATs+ AJo+ KQs",
            d:  "22+ A2+ K5s+ K9o+ Q7s+ QTo+ J7s+ JTo T7s+ 97s+ 87s 76s",
            sb: "22+ A2+ K5s+ K9o+ Q7s+ QTo+ J7s+ JTo T7s+ 97s+ 87s 76s"
        },
        critica: {
            ep: "44+ A8s+ ATo+ KJs+ KQo QJs",
            mp: "44+ A8s+ ATo+ KJs+ KQo QJs",
            co: "44+ A8s+ ATo+ KJs+ KQo QJs",
            d:  "22+ A2+ K5s+ K9o+ Q7s+ QTo+ J9s+ JTo T8s+ 98s 87s 76s",
            sb: "22+ A2+ K5s+ K9o+ Q7s+ QTo+ J9s+ JTo T8s+ 98s 87s 76s"
        }
    }

    attr_accessor :table

    def initialize(window, owner = nil)
        super window, owner
        @table = Table.new @window
        @table.createPlayers 6
        @table.seats[3].player.showcards = true
    end

    def generate(pos, etapa)
        rng = RANGOS_OR_7[etapa][pos]
        @range = CardRange.new @window, rng
        @table.dealNewHand 
        @table.setNewDealer DEALER_POS[pos]
    end

    def drawmyself
        @table.draw
    end
end
