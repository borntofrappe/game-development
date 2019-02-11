-- create a bird class
Bird = Class{}

--[[
  in the :init function set up the bird class with the following fields
  - image, creating an image file from the local png
  - width, retrieving the width from t  he image
  - height, retrieving the height from the image
  - x and y, the initial coordinates of the image
  (for now center it)
  - dy, for the vertical movement
]]

GRAVITY = 28

function Bird:init()
  self.image = love.graphics.newImage('Resources/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  -- offset by half the width/height to perfectly center the asset
  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
  self.dy = 0
end

-- in the :collides() function checks if the bird collides with the pipe passed as argument
function Bird:collides(pipe)
  -- return false if the bird cannot be overlapping with the pipe, else return true
  --[[
    horizontally
    the coordinate of the bird is past the coordinate of the pipe + the pipe's width
    or
    the coordinate of the bird is before the coordinate of the pipe - the bird's width
  ]]
  -- ! include small pixel values to make the game more forgiving
  if self.x > pipe.x + pipe.width - 4 or self.x < pipe.x - self.width + 4 then
    return false
  end
  --[[
    vertically
    the coordinate of the bird is more than the coordinate of the pipe + the pipe's height (lower in the graphic)
    or
    the coordinate of the bird is less than the coordinate of the pipe - the bird's height
  ]]
  if self.y > pipe.y + pipe.height - 4 or self.y < pipe.y - self.height + 4 then
    return false
  end

  -- are overlapping
  return true
end

-- in the :update(dt) function consider the vertical offset found in the dy field to move the bird according to gravity
function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  -- check if the space key was pressed
  if love.keyboard.wasPressed('space') then
    -- set dy to be negative, effectively moving the bird upwards
    self.dy = -7
  end

  self.y = self.y + self.dy
end

-- in the :render function render the image through the draw function
function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end
