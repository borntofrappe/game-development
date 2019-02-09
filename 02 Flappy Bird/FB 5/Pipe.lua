-- create a pipe class
Pipe = Class{}

-- for efficiency, create a local variable for the image
-- re-used for all instances of the class
local PIPE_IMAGE = love.graphics.newImage('Resources/pipe.png')
-- negative offset to move toward the left side of the screen
local PIPE_SCROLL = -40

--[[
  in the init function declare the following fields
  - x and y, for the coordinates
  - width, for the width of the image
]]

function Pipe:init()
  -- horizontally pushed past the right edge of the screen
  self.x = VIRTUAL_WIDTH
  -- vertically at a random height between a quarter and three quarters of the screen's height
  self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT * 3 / 4)
  self.width = PIPE_IMAGE:getWidth()
end

-- in the update(dt) function update the horizontal coordinate according to the scroll variable, multiplied by dt
function Pipe:update(dt)
  self.x = self.x + PIPE_SCROLL * dt
end


-- in the render function, use the `love.graphics.draw()` to show the asset on the screen
function Pipe:render()
  love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end