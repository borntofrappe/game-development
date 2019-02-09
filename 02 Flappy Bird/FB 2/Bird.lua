-- create a bird class
Bird = Class{}

--[[
  in the :init function set up the bird class with the following fields
  - image, creating an image file from the local png
  - width, retrieving the width from the image
  - height, retrieving the height from the image
  - x and y, the initial coordinates of the image
  (for now center it)
]]

function Bird:init()
  self.image = love.graphics.newImage('Resources/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  -- offset by half the width/height to perfectly center the asset
  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

-- in the :render function render the image through the draw function
function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

