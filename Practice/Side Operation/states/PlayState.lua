PlayState = Class({__includes = BaseState})

local GRAVITY = {2, 6}
local GRAVITY_MULTIPLIER = 0.4

local images = {
    ["wall"] = love.graphics.newImage("res/graphics/wall.png"),
    ["strip"] = love.graphics.newImage("res/graphics/strip.png")
}

function PlayState:init()
    local width_wall = images["wall"]:getWidth()
    self.thresholds = {
        [-1] = width_wall,
        [1] = VIRTUAL_WIDTH - width_wall
    }

    self.gravity = GRAVITY[1]
    self.direction = math.random(2) == 1 and 1 or -1
    self.dx = 0

    self.timer = 0
    self.interval = 4
    self.timer_progress = 0

    self.player = Player()
    self.score = 0
    self.trophy = false
    local width_strip = images["strip"]:getWidth()
    self.thresholds["trophy"] = {
        [-1] = self.thresholds[-1] + width_strip,
        [1] = self.thresholds[1] - width_strip
    }
end

function PlayState:enter(params)
    if params then
        self.gravity = params.gravity
        self.direction = params.direction
        self.timer = params.timer
        self.timer_progress = params.timer_progress
        self.player = params.player
        self.trophy = params.trophy
    end
end

function PlayState:move(direction)
    self.dx = self.gravity * direction * GRAVITY_MULTIPLIER
end

function PlayState:update(dt)
    if love.keyboard.was_pressed("escape") then
        gStateMachine:change("title")
    end

    if love.keyboard.was_pressed("p") or love.mouse.button_pressed[2] then
        gStateMachine:change(
            "pause",
            {
                ["gravity"] = self.gravity,
                ["direction"] = self.direction,
                ["timer"] = self.timer,
                ["timer_progress"] = self.timer_progress,
                ["player"] = self.player,
                ["trophy"] = self.trophy
            }
        )
    end

    if
        love.keyboard.was_pressed("left") or
            (love.mouse.button_pressed[1] and love.mouse.button_pressed[1].x < VIRTUAL_WIDTH / 2)
     then
        if not self.trophy and self.player.x + self.player.width > self.thresholds["trophy"][1] then
            self.trophy = true
        end
        self:move(-1)
    elseif
        love.keyboard.was_pressed("right") or
            (love.mouse.button_pressed[1] and love.mouse.button_pressed[1].x > VIRTUAL_WIDTH / 2)
     then
        if not self.trophy and self.player.x < self.thresholds["trophy"][-1] then
            self.trophy = true
        end

        self:move(1)
    end

    self.timer = self.timer + dt
    self.timer_progress = VIRTUAL_WIDTH * math.max(0, math.min(1, self.timer / self.interval)) * self.direction

    if self.timer > self.interval then
        self.score = self.score + self.timer
        self.timer = self.timer % self.interval
        self.gravity = math.random() * (GRAVITY[2] - GRAVITY[1]) + GRAVITY[1]
        if (math.random(2) == 1) then
            self.direction = self.direction * -1
        end
    end

    self.dx = self.dx + self.gravity * self.direction * dt
    self.player.x = self.player.x + self.dx
    if self.player.x < self.thresholds[-1] or self.player.x + self.player.width > self.thresholds[1] then
        self.score = self.score + self.timer
        gStateMachine:change(
            "score",
            {
                ["score"] = self.score,
                ["trophy"] = self.trophy
            }
        )
    end
end

function PlayState:render()
    love.graphics.setColor(0.333, 0.325, 0.408, 1)
    love.graphics.rectangle("fill", self.timer_progress, 0, VIRTUAL_WIDTH, 1)

    love.graphics.setColor(1, 1, 1, 1)
    if self.direction == 1 then
        love.graphics.draw(images["strip"], self.thresholds[1], 0, 0, -1, 1)
    else
        love.graphics.draw(images["strip"], self.thresholds[-1], 0)
    end

    love.graphics.setColor(1, 1, 1, 1)
    self.player:render()
end
