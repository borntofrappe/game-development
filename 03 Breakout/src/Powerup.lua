-- create a Powerup class
Powerup = Class{}

--[[
  in the :init function detail the variables which define the class
  - x and y, for the coordinates specified when creating an instance of the class
  - startingY, to keep a reference to the starting value for the y coordinate
  - width and height, matching the pixel value of the sprite to maintain the ratio
  - power, for the actual power up (8 variants differentiated on the basis of their index)
  - dy, to dictate the vertical speed of the power up
  - inPlay, to render the power up conditionally to the brick being hit (the flag is changed in the brick class) and to the paddle picking up the item
]]
function Powerup:init(x, y, key)
  self.x = x
  self.y = y
  self.startingY = y
  self.width = 16
  self.height = 16
  -- through the boolean passed as third argument specify the key powerup (the boolean is true for the instances of a locked brick)
  self.key = key
  self.power = self.key and 10 or math.random(9)
  self.dy = 50
  self.inPlay = false
end

-- update the power up to go down as long as it is in play and doesn't go past the bottom of the screen
function Powerup:update(dt)
  if self.inPlay then
    self.y = self.y + (self.dy * dt)
  end

  -- when reaching the bottom of the screen switch the boolean to false to stop updating/rendering the powerup
  if self.inPlay and self.y >= VIRTUAL_HEIGHT then
    self.inPlay = false
    -- if the powerup is for the key item, restore the y coordinate (this to have the powerup reset to its original position if the paddle fails to pick up the item)
    if self.key then
      self.y = self.startingY
    end
  end
end

-- in the collides(paddle) function check for a collision between the powerup and the paddle
-- aabb detection collision test
function Powerup:collides(paddle)
  if self.x + self.width / 2 < paddle.x or self.x - self.width / 2 > paddle.x + paddle.width then
    return false
  end
  if self.y + self.height / 2 < paddle.y or self.y - self.height / 2  > paddle.y + paddle.height then
    return false
  end

  return true
end

-- in the :render function use love.graphics to draw the powerup as identified from power
function Powerup:render()
  if self.inPlay then
    love.graphics.draw(gTextures['breakout'], gFrames['powerups'][self.power], self.x - self.width / 2, self.y - self.height / 2)
  end
end