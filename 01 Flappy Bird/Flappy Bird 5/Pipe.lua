Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage("res/graphics/pipe.png")
local PIPE_SCROLL = 60

function Pipe:init()
    self.width = PIPE_IMAGE:getWidth()

    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT / 8, VIRTUAL_HEIGHT / 8 * 7)
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
