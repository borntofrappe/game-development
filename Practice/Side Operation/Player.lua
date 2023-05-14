Player = Class {}

local GRAVITY = 0.25

local image = love.graphics.newImage("res/graphics/player.png")
local width = image:getWidth()
local height = image:getHeight()

function Player:init()
    self.image = image
    self.width = width
    self.height = height
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dx = 0
end

function Player:update(dt)
    self.dx = self.dx + GRAVITY * dt
    self.x = self.x + self.dx

    if love.keyboard.was_pressed("left") then
        self:turn("left")
    elseif love.keyboard.was_pressed("right") then
        self:turn("right")
    end
end

function Player:turn(direction)
    local dx = direction == "left" and -0.2 or 0.2
    self.dx = dx
end

function Player:render()
    love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
