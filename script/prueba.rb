class Card
    attr_accessor   :value
    attr_reader     :all_cards

    def initialize
        @value      = "Ah"
        @all_cards  = []
        k_cards = %w{ A K Q J T 9 8 7 6 5 4 3 2 }
        k_suits = %w{ h s c d }
        k_cards.product(k_suits).each do |c|
            @all_cards.push(c.join)
        end
    end

    def value=(val)
        @value = val if @all_cards.include?(val)
    end

    def next
        if @value != nil
            @all_cards[@all_cards.index(@value) + 1]
        end
    end

    def next!
        @value = self.next
    end

    def random
        @all_cards.sample
    end

    def random!
        @value = random
    end
end

c = Card.new
55.times do
    puts c.random!
end
puts c.value
