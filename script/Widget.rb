require 'gosu'

class Widget
    attr_accessor   :x, :y, :width, :height, :visible
    attr_accessor   :scale_x, :scale_y
    attr_accessor   :window, :owner
    attr_reader     :childs

    def initialize(window, owner = nil)
        @x, @y   = 0, 0
        @width   = 100
        @height  = 100
        @visible = true
        @scale_x = 1
        @scale_y = 1
        @window  = window
        @owner   = owner
        @childs  = []
    end

    def addChild(widget)
        widget.owner  = self
        widget.window = self.window
        @childs.push widget
    end

    def x=(nx)
        dist = nx - @x
        adddist "@x", dist
    end

    def y=(ny)
        dist = ny - @y
        adddist "@y", dist
    end

    def adddist(variable, dist)
        instance_variable_set variable, eval(variable) + dist
        @childs.each { |i| i.adddist variable, dist }
    end
    
    def drawxy(_x=nil, _y=nil, _sx=nil, _sy=nil)
        self.x = _x         if _x
        self.y = _y         if _y
        self.scale_x = _sx  if _sx
        self.scale_y = _sy  if _sy
        self.draw
    end

    def draw
        if @visible
            self.drawmyself
            @childs.each { |c| c.draw }
        end
    end

    protected :owner=, :window=, :adddist
end
