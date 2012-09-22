require 'gosu'
require_relative 'Exercise'

class GameWindow < Gosu::Window
    POSITIONS= [:co, :mp, :ep, :d, :sb]
    PHASES = [:inicial, :media, :critica]
    def initialize
        super 792, 546, false
        self.caption = "Trainer"
        @bg_image  = Gosu::Image.new self, "img/bg.jpg", true
        @exercise  = Exercise.new self
        @score     = 0
        @lbl_retro = Label.new self, "OK!", 100
        @lbl_retro.visible = false
        @lbl_score = Label.new self, "SCORE: 0", 30
        @lbl_score.align = :left
    end

    def new_exercise
        @exercise.generate POSITIONS.sample, PHASES.sample
    end

    def solve_exercise(movement)
        if @exercise.solution? movement
            @score += 1
            @lbl_score.text  = "SCORE: " + @score.to_s
            @lbl_retro.text  = "OK!"
            @lbl_retro.color = 0xFF00FF00
        else
            @lbl_retro.text  = "BAD!"
            @lbl_retro.color = 0xFFFF0000
        end
        @lbl_retro.visible = true
        @retro_time = Gosu::milliseconds
        new_exercise
    end

    def update
        ## Update lbl_retro
        if @lbl_retro.visible
            now = Gosu::milliseconds - @retro_time
            if now > 1023
                @lbl_retro.visible = false
            elsif now > 512
                @lbl_retro.color &= 0x00FFFFFF
                @lbl_retro.color += ((1024 - now) & 0x3FC) << 22
            end
        end
    end

    def button_up(id)
        case id
            when Gosu::KbR then solve_exercise :raise
            when Gosu::KbF then solve_exercise :fold
            when Gosu::KbC then solve_exercise :call
        end
    end

    def draw
        @bg_image.draw 0,0,0
        @exercise.draw 
        @lbl_retro.drawxy 390, 450
        @lbl_score.draw
    end
end

w = GameWindow.new 
w.show
