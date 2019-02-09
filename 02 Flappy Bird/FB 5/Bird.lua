-- create a bird class
Bird = Class{}

--[[
  in the :init function set up the bird class with the following fields
  - image, creating an image file from the local png
  - width, retrieving the width from the image
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

