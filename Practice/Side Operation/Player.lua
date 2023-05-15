Player = Class {}

local image = love.graphics.newImage("res/graphics/player.png")
local width = image:getWidth()
local height = image:getHeight()

function Player:init()
    self.image = image
    self.width = width
    self.height = height
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
end

function Player:render()
    love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
