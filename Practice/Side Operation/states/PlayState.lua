PlayState = Class({__includes = BaseState})

local GRAVITY = 0.25

function PlayState:init()
    local width_wall = gImages["wall"]:getWidth()
    self.thresholds = {
        ["left"] = width_wall,
        ["right"] = VIRTUAL_WIDTH - width_wall
    }

    self.dx = 0
    self.gravity = math.random(2) == 1 and GRAVITY or GRAVITY * -1
end

function PlayState:enter(params)
    self.player = params.player
    self.timer = 0
    self.interval = 3
end

function PlayState:turn(direction)
    local dx = direction == "left" and -0.2 or 0.2
    self.dx = dx
end

function PlayState:update(dt)
    if love.keyboard.was_pressed("escape") then
        gStateMachine:change("title")
    end

    if love.keyboard.was_pressed("left") then
        self:turn("left")
    elseif love.keyboard.was_pressed("right") then
        self:turn("right")
    end

    self.timer = self.timer + dt

    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        if (math.random(2) == 1) then
            self.gravity = self.gravity * -1
        end
    end

    if self.player.x > self.thresholds["left"] and self.player.x + self.player.width < self.thresholds["right"] then
        self.dx = self.dx + self.gravity * dt
        self.player.x = self.player.x + self.dx
    end
end

function PlayState:render()
    if self.gravity > 0 then
        love.graphics.draw(gImages["strip"], self.thresholds["right"], 0, 0, -1, 1)
    else
        love.graphics.draw(gImages["strip"], self.thresholds["left"], 0)
    end

    self.player:render()
end
