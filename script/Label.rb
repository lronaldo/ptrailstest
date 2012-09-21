require_relative 'Widget'

class Label < Widget
    ALIGNMENTS = [ :center, :left, :right ]
    attr_accessor :font, :align, :text, :size
    attr_accessor :color, :mode

    def initialize(window, text = "", fs = 20, owner = nil)
        super window, owner
        @x        = 0
        @y        = 0
        @text     = text
        @align    = :center
        @size     = fs
        @font     = Gosu::Font.new(window, Gosu::default_font_name, @size)
        @color    = 0xFFFFFFFF
        @mode     = :default
    end

    def fontsize=(nfs)
        @size = nfs
        @font = Gosu::Font.new(window, Gosu::default_font_name, @size)
    end

    ## Render the label
    def drawmyself
        x = @x
        y = @y
        if @align != :left
            w = @font.text_width @text, @scale_x
            if @align == :center
                x = x - w / 2
            elsif @align == :right
                x = x - w
            end
        end
        @font.draw @text, x, y, 0, @scale_x, @scale_y, @color, @mode
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
