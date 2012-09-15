require './Renderer'
require './CardRange'
require './Table'
require './Label'
include Curses

ep50 = { ep:     CardRange.new("55+ ATo+ A9s+ KJo+ KTs+ QJo+ QTs+ JTs  T9s"),
         mp:     CardRange.new("22+ A9o+ A7s+ KTo+ K9s+ QTo+ Q9s+ JTo  J9s+ T9s  98s  87s"),
         co_des: CardRange.new("22+ A8o+ A2s+ KTo+ K8s+ QTo+ Q9s+ JTo  J9s+ T9s  98s  87s"),
         co_fav: CardRange.new("22+ A2+  K8o+ K5s+ Q9o+ Q8s+ J9o+ J8s+ T9o  T8s+ 97s+ 86s+ 76s 65s 54s")
       }   

SCR = Renderer.instance
SCR.withcurses do
#    SCR.setDefaultColor
    SCR.setxy 0,0
    t = Table.new
    t.render
    while !getch
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
=end
end
