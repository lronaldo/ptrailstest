require './Card'
require 'matrix'

# Redefining class Matrix to add element-modification capabilities
class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class CardRange
    CARDS = %w{ 2 3 4 5 6 7 8 9 T J Q K A }
    SUITS = %w{ h c s d }
    FULL_SUIT_CELL    = %w{ "hh" "cc" "ss" "dd" }
    FULL_OFFSUIT_CELL = %w{ "hc" "ch" "hs" "sh" "hd" "dh" "cs" "sc" "cd" "dc" "sd" "ds" }
    attr_reader :cardpairs

    def initialize
        self.reset
    end
    
    # No card is selected. 0% Range
    def reset
        @cardpairs = Matrix.build(CARDS.length, CARDS.length) { [] }
    end

    # Get cell index for 2 cards
    # c1 and c2 should be Cards
    def cell_index(c1, c2)
        if c1.valid && c2.valid
            # Get values and order them (v1 > v2)
            v1 = CARDS.index(c1.value)
            v2 = CARDS.index(c2.value) 
            s1 = c1.suit
            s2 = c2.suit
            v1, v2, s1, s2 = v2, v1, s2, s1 if v1 < v2 

            # If they are same suit, then swith coords
            v1, v2, s1, s2 = v2, v1, s2, s1 if s1 == s2

            return v1, v2, s1, s2
        end
    end

    # Check if two cards are in the range
    # c1 and c2 must be cards
    def include?(c1, c2)
        v1, v2, s1, s2 = cell_index(c1, c2)
        if v1
            @cardpairs[v1, v2].include?(s1 + s2)
        end
    end

    # Selects a pocket pair
    def select_a_pocket(text_card)
    end

    # Selects a hand for all suits
    def select_a_hand(tc1, tc2)
        i = CARDS.index(tc1)
        j = CARDS.index(tc2)
        if i && j
            @cardpairs[i, j] = FULL_OFFSUIT_CELL 
            @cardpairs[j, i] = FULL_SUIT_CELL 
        end
    end

    # Selects an offsuited hand
    def select_an_offsuit_hand(tc1, tc2)

    # Selects a textual range of cards
    def select_a_range(text)
        if text.is_a?(String)
            case text.length
                when 2 ## 77,AK
                    i = CARDS.index(text[0])
                    j = CARDS.index(text[1])
                    if text[0] == text[1] && i
                        @cardpairs[i, i] = FULL_OFFSUIT_CELL
                    else if i && j
                        @cardpairs[i, j] = FULL_OFFSUIT_CELL 
                        @cardpairs[j, i] = FULL_SUIT_CELL 
                    end
                when 3 ## AK+, AKo, AKs, 77+
                    i = CARDS.index(text[0])
                    j = CARDS.index(text[1])
                    if text[2] == "+" && i && j
                        (j...CARDS.length).each do |z|
                            @cardpairs[i, z] = FULL_OFFSUIT_CELL
                            @cardpairs[z, i] = FULL_SUIT_CELL
                        end
                    else if text[2] == "o" && i && j
                        @cardpairs[i, j] = FULL_OFFSUIT_CELL
                    else if text[2] == "s" && i && j
                        @cardpairs[j, i] = FULL_SUIT_CELL
                    end
                when 4 ## AKo+, AKs+, AhKh
                    i = CARDS.index(text[0])
                    j = CARDS.index(text[1])
                    if text[4] == "+" && i && j
                        ## AKo+, AKs+
                        ## TODO
                    else
                        ## AhKh
                        ## TODO
                    end
            end
        end
    end
end

a = CardRange.new
c1, c2 = Card.new, Card.new
c2.strvalue="2c"
p a.include?(c1, c1)
p a.include?(c1, c2)
