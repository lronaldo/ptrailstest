require 'gosu'
require_relative 'Exercise'

class GameWindow < Gosu::Window
    POSITIONS= [:co, :mp, :ep, :d, :sb]
    PHASES = [:inicial, :media, :critica]
    def initialize
        super 792, 546, false
        self.caption = "Trainer"
        @bg_image = Gosu::Image.new self, "img/bg.jpg", true
        @exercise = Exercise.new self
    end

    def new_exercise
        @exercise.generate POSITIONS.sample, PHASES.sample
    end

    def update
        sleep 0.02
    end

    def button_up(id)
        new_exercise
    end

    def draw
        @bg_image.draw 0,0,0
        @exercise.draw 
    end
end

w = GameWindow.new 
w.show
