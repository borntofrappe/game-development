-- create a Paddle class
Paddle = Class{}

--[[
  in the :init function detail the variables which define the class
  - x and y, for the coordinates and by default in the bottom section
  - width and height, matching the pixel value of the sprite to maintain the ratio
  - dx, for the horizontal speed
  - skin, for the color of the paddle  |
  - size, for the size of the paddle   |__- both are used knowing that the paddles table sorts the paddles in order of size and then color
]]
function Paddle:init()
  self.size = 2
  self.width = self.size * 32
  self.height = 16
  self.skin = 1
  self.x = VIRTUAL_WIDTH / 2 - self.width / 2
  self.y = VIRTUAL_HEIGHT - 32
  self.dx = 0
  self.speed = 160 + (4 - self.size) * 20
end

-- in the :update(dt) function, describe how the paddle alters its horizontal position considering a key press and the dx value
function Paddle:update(dt)
  -- when pressing the left or right key, update `dx` according to the PADDLE_SPEED constant
  if love.keyboard.isDown('left') then
    self.dx = -self.speed * dt
  elseif love.keyboard.isDown('right') then
    self.dx = self.speed * dt
  -- set the default speed to 0 to avoid continuing the horizontal movement
  else
    self.dx = 0
  end

  -- clamp the position to the windows' boundaries using math.max and math.min
  if self.dx < 0 then
    self.x = math.max(0, self.x + self.dx)
  else
    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx)
  end
end

-- in the :render function, use the love.graphics function to draw the paddle as identified from the skin and size
function Paddle:render()
  --[[
    arguments
    - the image
    - the quad
    - x and y coordinates
  ]]
  love.graphics.draw(gTextures['breakout'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end