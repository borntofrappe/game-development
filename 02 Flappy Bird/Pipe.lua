-- create a pipe class
Pipe = Class{}

-- for efficiency, create a local variable for the image
-- re-used for all instances of the class
local PIPE_IMAGE = love.graphics.newImage('Resources/graphics/pipe.png')

-- create variables for the speed of the pipe as well as the width and height values
PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

--[[
  in the init function declare the following fields
  - x and y, for the coordinates
  - width, for the width of the image
  - height, encompassing the screen
  - orientation, describing whether the pipe ought to be positioned at the top or bottom of the screen
  ! the class is instantiated with a defined orientation and y value
]]

function Pipe:init(orientation, y)
  self.x = VIRTUAL_WIDTH
  self.y = y
  self.width = PIPE_IMAGE:getWidth()
  self.height = PIPE_HEIGHT
  self.orientation = orientation
end

-- ! no need for an update function, as the movement is updated by the PipePair class

-- in the render function, use the `love.graphics.draw()` to show the asset on the screen
function Pipe:render()
  --[[
    .draw accepts here 6 arguments
    - drawable
    - horizontal coordinate
    - vertical coordinate
    - rotation
    - horizontal scale
    - vertical scale

    depending on the orientation flip the image by applying a -1 vertical scale
    as the -1 scaled image is scaled in place, offset the vertical coordinate by the height of the pipe (always and only when the pipe is flipped)
  ]]
  love.graphics.draw(
    PIPE_IMAGE,
    self.x,
    self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y,
    0,
    1,
    self.orientation == 'top' and -1 or 1
  )
end