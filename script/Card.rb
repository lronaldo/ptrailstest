class Card
    ALL_CARDS = ["Ah", "As", "Ac", "Ad", "Kh", "Ks", "Kc", "Kd", "Qh", "Qs", "Qc", "Qd", "Jh", "Js", "Jc", "Jd", "Th", "Ts", "Tc", "Td", "9h", "9s", "9c", "9d", "8h", "8s", "8c", "8d", "7h", "7s", "7c", "7d", "6h", "6s", "6c", "6d", "5h", "5s", "5c", "5d", "4h", "4s", "4c", "4d", "3h", "3s", "3c", "3d", "2h", "2s", "2c", "2d"]

    def initialize(val = "Ah")
        self.value = val
    end

    def valid
        @value.is_a?(Integer) and ALL_CARDS[@value] != nil
    end

    def value
        ALL_CARDS[@value] if self.valid
    end

    def value=(val)
        @value = ALL_CARDS.index(val)
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
        if self.valid
            "|" + ALL_CARDS[@value]  + "|"
        else
            "NotACard"
        end
    end
end
