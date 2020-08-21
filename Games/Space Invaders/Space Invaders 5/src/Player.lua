Player = Class {}

function Player:init()
  self.width = 27
  self.height = 21
  self.x = WINDOW_WIDTH / 2 - self.width / 2
  self.y = WINDOW_HEIGHT - self.height - 8

  self.dx = 0
end

function Player:update(dt)
  if love.keyboard.isDown("left") then
    self.dx = -PLAYER_SPEED
  elseif love.keyboard.isDown("right") then
    self.dx = PLAYER_SPEED
  else
    self.dx = 0
  end

  self.x = math.max(0, math.min(WINDOW_WIDTH - self.width, self.x + self.dx * dt))
end

function Player:render()
  love.graphics.draw(gTextures["space-invaders"], gFrames["player"], self.x, self.y)
end
