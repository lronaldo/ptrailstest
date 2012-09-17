require 'gosu'

class Widget
    attr_accessor   :x, :y, :width, :height
    attr_reader     :window
    attr_reader     :owner
    attr_reader     :childs

    def initialize(window, owner = nil)
        @x, @y  = 0, 0
        @width  = 100
        @height = 100
        @window = window
        @owner  = owner
        @childs = []
    end

    def addchild(widget)
        widget.owner  = self
        widget.window = self.window
        @childs.push widget
    end

    def posx
        if @owner
            @x + @owner.x
        else
            @x
        end
    end
    
    def posy
        if @owner
            @y + @owner.y
        else
            @y
        end
    end

    def draw
        self.drawmyself
        @childs.each { |c| c.draw }
    end
end
