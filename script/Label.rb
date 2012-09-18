require_relative 'Widget'

class Label < Widget
    ALIGNMENTS = [ :center, :left, :right ]
    attr_accessor :font, :align, :text
    attr_accessor :color, :mode, :factorx, :factory

    def initialize(window, text = "", owner = nil)
        super window, owner
        @x        = 0
        @y        = 0
        @text     = text
        @align    = :center
        @font     = Gosu::Font.new(window, Gosu::default_font_name, 20)
        @color    = 0xFFFFFFFF
        @mode     = :default
        @factorx  = 1
        @factory  = 2
    end

    ## Render the label
    def drawmyself
        x = @x
        y = @y
        if @align != :left
            w = @font.text_width @text, @factorx
            if @align == :center
                x = x - w / 2
            elsif @align == :right
                x = x - w
            end
        end
        @font.draw @text, x, y, 0, 1, 1, @color, @mode
    end

    ## Render Label
=begin
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
=end
end
