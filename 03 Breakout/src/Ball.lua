-- create a Ball class
Ball = Class{}

--[[
  in the :init function detail the variables which define the class
  - x and y, for the coordinates
  - width and height, matching the pixel value of the sprite to maintain the ratio
  - dx and dy, for the horizontal and vertical speed
  - skin, for the color of the ball
]]
function Ball:init()
  self.x = 0
  self.y = 0
  self.width = 8
  self.height = 8
  -- initialize dx and dy with random values in a range
  -- this to have the ball move at varying speed , but always upwards (at first starting from the paddle)
  self.dx = math.random(2) == 1 and math.random(60, 120) or math.random(-60, -120)
  self.dy = math.random(-80, -140)
  self.skin = 1
end

-- in the collides(paddle) function, check for a collision using aabb collision test
function Ball:collides(paddle)
  if self.x < paddle.x - self.width or self.x > paddle.x + paddle.width then
    return false
  end
  if self.y < paddle.y - self.height or self.y > paddle.y + paddle.height then
    return false
  end

  return true
end

-- in the reset() function, set the ball to the center of the screen
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 4
  self.y = VIRTUAL_HEIGHT / 2 - 4
  self.dx = 0
  self.dy = 0
end

-- in the :update(dt) function, describe how the ball alters its horizontal and vertical position considering the passing of time
-- the passing of time and when the ball reaches the edges of the screen
function Ball:update(dt)
  self.x = self.x + (self.dx * dt)
  self.y = self.y + (self.dy * dt)

  -- account for a bounce on the ball switching the pertinent value in the opposite direction
  -- ! remember to set the coordinate outside of the region to avoid having the condition evaluate to true continuously
  if self.x <= 0 then
    self.x = 0
    self.dx = -self.dx
    gSounds['wall_hit']:play()
  end

  if self.x >= VIRTUAL_WIDTH - self.width then
    self.x = VIRTUAL_WIDTH - self.width
    self.dx = -self.dx
    gSounds['wall_hit']:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = -self.dy
    gSounds['wall_hit']:play()
  end
end

-- in the :render function, use the love.graphics function to draw the ball as identified from the skin
function Ball:render()
  love.graphics.draw(gTextures['breakout'], gFrames['balls'][self.skin], self.x, self.y)
end