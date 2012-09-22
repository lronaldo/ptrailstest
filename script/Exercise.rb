require_relative 'Table'

class Exercise < Widget
    EP50 = { ep: CardRange.new("55+ ATo+ A9s+ KJo+ KTs+ QJo+ QTs+ JTs  T9s"),
             mp: CardRange.new("22+ A9o+ A7s+ KTo+ K9s+ QTo+ Q9s+ JTo  J9s+ T9s  98s  87s"),
             co_des: CardRange.new("22+ A8o+ A2s+ KTo+ K8s+ QTo+ Q9s+ JTo  J9s+ T9s  98s  87s"),
             co_fav: CardRange.new("22+ A2+  K8o+ K5s+ Q9o+ Q8s+ J9o+ J8s+ T9o  T8s+ 97s+ 86s+ 76s 65s 54s")
       }   

    attr_accessor :table
    attr_accessor :position

    def initialize(window, owner = nil)
        super window, owner
        @table = Table.new @window
    end

    def define()
    end
end
