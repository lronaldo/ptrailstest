class Card
    CARDS = %w{ 2 3 4 5 6 7 8 9 T J Q K A }
    SUITS = %w{ h d s c }
    ALL_CARDS = ["Ah", "As", "Ac", "Ad", "Kh", "Ks", "Kc", "Kd", "Qh", "Qs", "Qc", "Qd", "Jh", "Js", "Jc", "Jd", "Th", "Ts", "Tc", "Td", "9h", "9s", "9c", "9d", "8h", "8s", "8c", "8d", "7h", "7s", "7c", "7d", "6h", "6s", "6c", "6d", "5h", "5s", "5c", "5d", "4h", "4s", "4c", "4d", "3h", "3s", "3c", "3d", "2h", "2s", "2c", "2d"]

    def initialize(val = "Ah")
        @value = 0
    end

    def valid
        @value.is_a?(Integer) and ALL_CARDS[@value] != nil
    end

    def strvalue=(val)
        @value = ALL_CARDS.index(val)
    end

    def value
        ALL_CARDS[@value][0] if self.valid
    end

    def value=(val)
        if self.valid and CARDS.include?(val)
            v = ALL_CARDS[@value]
            v[0] = val
            @value = ALL_CARDS.index(v)
        end
    end

    def suit
        ALL_CARDS[@value][1] if self.valid
    end

    def suit=(val)
        if self.valid and SUITS.include?(val)
            v = ALL_CARDS[@value]
            v[1] = val
            @value = ALL_CARDS.index(v)
        end
    end

    def to_s
        if self.valid
            ALL_CARDS[@value]
        else
            "NotACard"
        end
    end

    def next
        Card.new(ALL_CARDS[ @value + 1 ]) if self.valid
    end

    def next!
        @value += 1 if self.valid
        self
    end

    def random
        Card.new(ALL_CARDS[rand(0...ALL_CARDS.lenght)])
    end

    def random!
        @value = rand(0...ALL_CARDS.lenght)
        self
    end

    def inspect
        "|" + self.to_s  + "|"
    end

    # other must be a card
    def same_suit?(other)
        if valid && other.valid
            self.suit == other.suit
        end
    end
end
