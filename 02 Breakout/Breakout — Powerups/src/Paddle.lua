Paddle = Class {}

function Paddle:init(x, y)
  self.x = x
  self.y = y
  self.width = PADDLE_WIDTH
  self.height = PADDLE_HEIGHT

  self.dx = 0

  self.color = 1
  self.size = 2
end

function Paddle:shrink()
  if self.size > 1 then
    self.size = self.size - 1
    self.width = self.size * PADDLE_WIDTH / 2
    self.x = self.x + PADDLE_WIDTH / 2
  end
end

function Paddle:grow()
  if self.size < 4 then
    self.size = self.size + 1
    self.width = self.size * PADDLE_WIDTH / 2
    self.x = self.x - PADDLE_WIDTH / 2
  end
end

function Paddle:update(dt)
  if love.keyboard.isDown("left") then
    self.dx = PADDLE_SPEED * dt * -1
  elseif love.keyboard.isDown("right") then
    self.dx = PADDLE_SPEED * dt
  else
    self.dx = 0
  end

  if self.dx < 0 then
    self.x = math.max(0, self.x + self.dx)
  else
    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx)
  end
end

function Paddle:render()
  love.graphics.draw(
    gTextures["breakout"],
    gFrames["paddles"][self.size + PADDLE_COLORS * (self.color - 1)],
    self.x,
    self.y
  )
end
