-- create a Powerup class
Powerup = Class{}

--[[
  in the :init function detail the variables which define the class
  - x and y, for the coordinates specified when creating an instance of the class
  - width and height, matching the pixel value of the sprite to maintain the ratio
  - power, for the actual power up (8 variants differentiated on the basis of their index)
  - dy, to dictate the vertical speed of the power up
  - inPlay, to render the power up in the screen and as long as the power up doesn't coliide with the paddle
]]
function Powerup:init(x, y)
  self.x = x
  self.y = y
  self.width = 16
  self.height = 16
  self.power = math.random(8)
  self.dy = 50
  self.inPlay = true
end

-- update the power up to go down as long as it is in play and doesn't go past the bottom of the screen
function Powerup:update(dt)
  if self.inPlay then
    self.y = self.y + (self.dy * dt)
  end

  if self.inPlay and self.y >= VIRTUAL_HEIGHT then
    self.inPlay = false
  end
end

-- in the collides() function check for a collision between the power up and the paddle
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