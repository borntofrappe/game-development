PlayState = Class({__includes = BaseState})

function PlayState:init()
    local width_wall = gImages["wall"]:getWidth()
    self.thresholds = {
        ["left"] = width_wall,
        ["right"] = VIRTUAL_WIDTH - width_wall
    }
end

function PlayState:enter(params)
    self.player = params.player
end

function PlayState:update(dt)
    if love.keyboard.was_pressed("escape") then
        gStateMachine:change("title")
    end

    if self.player.x > self.thresholds["left"] and self.player.x + self.player.width < self.thresholds["right"] then
        self.player:update(dt)
    end
end

function PlayState:render()
    love.graphics.draw(gImages["strip"], self.thresholds["right"], 0, 0, -1, 1)

    self.player:render()
end
