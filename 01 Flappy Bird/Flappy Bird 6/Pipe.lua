Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage("res/graphics/pipe.png")

function Pipe:init(x, y, origin)
    self.x = x
    self.y = y
    self.origin = origin
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y, 0, 1, self.origin == "top" and -1 or 1)
end
