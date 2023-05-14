PlayState = Class({__includes = BaseState})

local GRAVITY = {2, 4}
local COUNTER_GRAVITY = 0.4

function PlayState:init()
    local width_wall = gImages["wall"]:getWidth()
    self.thresholds = {
        [-1] = width_wall,
        [1] = VIRTUAL_WIDTH - width_wall
    }

    self.gravity = GRAVITY[1]
    self.direction = math.random(2) == 1 and 1 or -1
    self.dx = 0

    self.timer = 0
    self.interval = 4
    self.progress = 0

    self.player = Player()
end

function PlayState:enter(params)
end

function PlayState:move(direction)
    self.dx = self.gravity * direction * COUNTER_GRAVITY
end

function PlayState:update(dt)
    if love.keyboard.was_pressed("escape") then
        gStateMachine:change("title")
    end

    if love.keyboard.was_pressed("left") then
        self:move(-1)
    elseif love.keyboard.was_pressed("right") then
        self:move(1)
    end

    self.timer = self.timer + dt
    self.progress = VIRTUAL_WIDTH * math.max(0, math.min(1, self.timer / self.interval)) * self.direction

    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        self.gravity = math.random() * (GRAVITY[2] - GRAVITY[1]) + GRAVITY[1]
        if (math.random(2) == 1) then
            self.direction = self.direction * -1
        end
    end

    if self.player.x > self.thresholds[-1] and self.player.x + self.player.width < self.thresholds[1] then
        self.dx = self.dx + self.gravity * self.direction * dt
        self.player.x = self.player.x + self.dx
    end
end

function PlayState:render()
    love.graphics.setColor(1, 1, 1, 1)

    if self.direction == 1 then
        love.graphics.draw(gImages["strip"], self.thresholds[1], 0, 0, -1, 1)
    else
        love.graphics.draw(gImages["strip"], self.thresholds[-1], 0)
    end

    love.graphics.draw(gImages["progress"], self.progress, 0)

    self.player:render()
end
