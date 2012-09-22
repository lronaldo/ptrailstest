require 'gosu'
require_relative 'CardRange'
require_relative 'Table'
require_relative 'Label'

class GameWindow < Gosu::Window
    def initialize
        super 792, 546, false
        self.caption = "Trainer"
        @bg_image = Gosu::Image.new self, "img/bg.jpg", true
        @table    = Table.new self
        @table.createplayers 4
        @table.dealNewHand 
    end

    def update
        sleep 0.02
    end

    def draw
        @bg_image.draw 0,0,0
        @table.draw 
    end
end

w = GameWindow.new 
w.show

=begin
SCR = CursesRenderer.instance
SCR.withcurses do
#    SCR.setDefaultColor
    SCR.setxy 0,0
    t = Table.new
    t.render
    while !SCR.getchar
    end

=begin


    points = 0
    c1, c2 = Card.new, Card.new
    KEYS = [ "r", "f", " " ]
    while true
        c1.random!
        c2.random!
        k = ep50.keys.sample
        answer = ep50[k].include?(c1, c2)
        SCR << ("[ #{k} ] #{c1}#{c2} (r/f) ")
        key = nil
        while !KEYS.include?(key)
            key = getch; 
            sleep 0.05;
        end
        SCR << "#{key} "
        break if key == " "
        if (answer && key == "r") || (!answer && key == "f")
            points+=1
            SCR.changeColor A_BOLD, COLOR_GREEN, COLOR_BLACK
            SCR << "OK!"
            SCR.setDefaultColor
        else
            points-=1
            SCR.changeColor A_BOLD, COLOR_RED, COLOR_BLACK
            SCR << "Bad"
            SCR.setDefaultColor
        end
        SCR.nl
    end
end
=end
