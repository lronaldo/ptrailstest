require 'singleton'
require 'curses'

class CursesRenderer
    include Singleton
    include Curses
    BASIC_COLORS = [ Curses::COLOR_BLACK, Curses::COLOR_WHITE,  Curses::COLOR_RED, 
                     Curses::COLOR_GREEN, Curses::COLOR_YELLOW, Curses::COLOR_MAGENTA, 
                     Curses::COLOR_CYAN, Curses::COLOR_BLUE ]

    def initialize
    end

    def start
        init_screen
        start_color
        self.resetcolors
        noecho
        cbreak
        Curses::timeout=0
    end

    ## Reset colors
    def resetcolors
        i = 0
        @colors = {}
        BASIC_COLORS.each do |c1|
            BASIC_COLORS.each do |c2|
                init_pair(i, c1, c2)
                @colors[c1] = {} if !@colors.key?(c1)
                @colors[c1][c2] = i
                i += 1
            end
        end
    end

    ## Create a curses block of code
    def withcurses
        begin 
            self.start
            yield
        ensure
            close_screen
        end
    end

    ## Change writting color
    def changeColor(attr, fc, bc)
        if has_colors?
            cp = @colors[fc][bc]
            attrset(attr | color_pair(cp)) if cp != nil
        end
    end

    ## Reset to initial colors
    def setDefaultColor
        self.changeColor A_NORMAL, COLOR_WHITE, COLOR_BLACK
    end

    ## Set position on screen
    def setxy(x, y)
        setpos y, x
    end

    ## Write string
    def <<(str)
        addstr str
        refresh
    end

    ## New line
    def nl
        addstr "\n"
        refresh
    end

    ## Repeat a character
    def repchar(char, n)
        n.times { addch char }
        refresh
    end
end
