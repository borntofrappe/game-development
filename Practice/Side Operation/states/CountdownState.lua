CountdownState = Class({__includes = BaseState})

function CountdownState:init()
    self.timer = 0
    self.interval = 0.5
    self.countdown = 3

    self.player = Player()
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        self.countdown = self.countdown - 1
        if self.countdown == 0 then
            gStateMachine:change("play")
        end
    end
end

function CountdownState:render()
    love.graphics.setColor(0.333, 0.325, 0.408, 1)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, 1)

    love.graphics.setColor(1, 1, 1, 1)
    self.player:render()

    drawOverlay()

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf(self.countdown, 0, VIRTUAL_HEIGHT / 2 - gFont:getHeight() / 2, VIRTUAL_WIDTH, "center")
end
