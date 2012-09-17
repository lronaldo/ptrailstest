require './CursesRenderer'

class Label
    include Curses
    SCR = CursesRenderer.instance

    ALIGNMENTS = [ :center, :left, :right ]
    attr_accessor :x, :y, :wide
    attr_accessor :attr, :fg_color, :bg_color
    attr_accessor :align, :text

    def initialize(text = "", wide = 5)
        @x        = 0
        @y        = 0
        @wide     = wide
        @text     = text
        @attr     = A_NORMAL
        @fg_color = COLOR_WHITE
        @bg_color = COLOR_BLACK
        @align    = :center
    end

    ## Render Label
    def render(xoff = 0, yoff = 0)
        x = @x + xoff
        y = @y + yoff
        
        # Cut exceeding chars and align
        t = @text
        t = t[0...@wide] if t.length > @wide
        case @align
            when :left   then t = t.ljust @wide
            when :right  then t = t.rjust @wide
            else              t = t.center @wide
        end
        SCR.setxy x, y
        SCR.changeColor @attr, @fg_color, @bg_color
        SCR << t
        SCR.setDefaultColor
    end
end
