CountdownState = Class {__includes = BaseState}

function CountdownState:init()
    self.timer = 0
    self.threshold = 0.5
    self.countdown = 3
    sounds["countdown"]:play()
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.threshold then
        self.countdown = self.countdown - 1
        self.timer = self.timer % self.threshold

        if self.countdown == 0 then
            gStateMachine:change("play")
        end

        sounds["countdown"]:play()
    end
end

function CountdownState:render()
    love.graphics.setFont(font_big)
    love.graphics.printf(self.countdown, 0, VIRTUAL_HEIGHT / 2 - font_big:getHeight() / 2, VIRTUAL_WIDTH, "center")
end
