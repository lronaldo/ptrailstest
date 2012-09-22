require 'gosu'
require_relative 'Exercise'

class GameWindow < Gosu::Window
    def initialize
        super 792, 546, false
        self.caption = "Trainer"
        @bg_image = Gosu::Image.new self, "img/bg.jpg", true
        @exercise = Exercise.new self
        @exercise.generate :ep, :media
    end

    def update
        sleep 0.02
    end

    def draw
        @bg_image.draw 0,0,0
        @exercise.draw 
    end
end

w = GameWindow.new 
w.show
