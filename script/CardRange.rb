require 'matrix'
require_relative 'Card'
require_relative 'Widget'

# Redefining class Matrix to add element-modification capabilities
class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class CardRange < Widget
    CARDS = %w{ 2 3 4 5 6 7 8 9 T J Q K A }
    SUITS = %w{ h c s d }
    FULL_SUIT_CELL    = %w{ hh cc ss dd }
    FULL_OFFSUIT_CELL = %w{ hc ch hs sh hd dh cs sc cd dc sd ds }
    attr_reader :cardpairs

    def initialize(window, strranges = "", owner = nil)
        super window, owner
        self.reset
        self.select_ranges(strranges)
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
        @cardpairs[v1, v2].include? s1 + s2 if v1
    end

    # Selects a hand with its concrete suits
    # c1 and c2 ar cards
    def select_concrete_hand(c1, c2)
        v1, v2, s1, s2 = cell_index c1, c2
        @cardpairs[v1, v2] = @cardpairs[v1, v2] | [ s1 + s2 ] if v1
    end

    # Selects a pocket pair
    def select_pocket(i)
        self.select_hand i, i, :offsuit
    end

    # Selects a hand by indexes
    def select_hand(i, j, suit)
        ##logging## p "Selecting #{i},#{j},#{suit}"

        if i == j || suit == :offsuit || suit == :both
            @cardpairs[i, j] = FULL_OFFSUIT_CELL
        end

        if i != j && (suit == :suit || suit == :both)
            @cardpairs[j, i] = FULL_SUIT_CELL
        end
    end

    # Select upper range (AK+, AJ+,...) by indexes
    def select_hands_upper_range(i, j, suit)
        (j...i).each do |z|
            self.select_hand i, z, suit
        end
    end

    # Select upper range pockets (77+, ...)
    def select_pockets_upper_range(i)
        (i...CARDS.length).each do |z|
            self.select_pocket z
        end
    end

    # Selects a textual range of cards
    def select_single_range(text)
        ##logging## p "Selecting Range #{text}..."

        if text.is_a?(String)
            case text.length
                when 2 then ## 77,AK
                    i = CARDS.index text[0]
                    j = CARDS.index text[1]
                    if text[0] == text[1] && i
                        self.select_pocket i
                    elsif i && j
                        self.select_hand i, j, :both
                    end
                when 3 then ## AK+, AKo, AKs, 77+
                    i = CARDS.index text[0]
                    j = CARDS.index text[1]
                    s = nil
                    case text[2]
                        when "+" then s = :both
                        when "o" then s = :offsuit
                        when "s" then s = :suit
                    end
                    if i && j and i == j
                        self.select_pockets_upper_range i
                    elsif s && s != :both
                        self.select_hand i, j, s
                    elsif s == :both
                        self.select_hands_upper_range i, j, s
                    end
                when 4 then ## AKo+, AKs+, AhKh
                    i = CARDS.index text[0]
                    j = CARDS.index text[1]
                    if text[3] == "+" && i && j
                        s = nil
                        case text[2]
                            when "o" then s = :offsuit
                            when "s" then s = :suit
                        end
                        self.select_hands_upper_range i, j, s
                    else
                        c1 = Card.new @window, text[0..1]
                        c2 = Card.new @window, text[2..3]
                        if c1.valid && c2.valid
                            self.select_concrete_hand c1, c2
                        end
                    end
            end
        end
    end

    # Select multiple ranges separated by commas or spaces
    def select_ranges(text)
        text.split(/[^A|K|Q|J|T|9|8|7|6|5|4|3|2|o|s|h|c|s|d|\+]+/).each do |t|
            select_single_range(t)
        end
    end
end

=begin
hands = [ ["Ah", "5s"], ["As", "5s"],["Ad", "7d"], ["Ah", "Ad"], ["5s", "4c"],
          ["Ad", "5h"], ["Ah", "5h"],["As", "7h"], ["As", "Ac"], ["5c", "5s"],
          ["Ah", "Ts"], ["As", "Qs"],["Ad", "Kd"], ["Ah", "4d"], ["9s", "7c"],
          ["7h", "7s"], ["Ks", "Js"],["8d", "7d"], ["Jh", "Td"], ["Qs", "5c"] ]
a = CardRange.new
a.select_ranges("55+ : AT+ %&$ KT+ {} QT+ _- JT+")
c1, c2 = Card.new, Card.new
hands.each do |h|
    c1.strvalue = h[0]
    c2.strvalue = h[1]
    print "Incluye (#{c1}#{c2})? "
    p a.include?(c1, c2)
end
=end
