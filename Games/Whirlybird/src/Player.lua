Player = Class {}

function Player:init(x, y)
  self.width = PLAYER_WIDTH
  self.height = PLAYER_HEIGHT
  self.x = x
  self.y = y
  self.y0 = y

  self.dy = PLAYER_JUMP
end

function Player:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy

  if self.y >= self.y0 then
    self.y = self.y0
    self.dy = -PLAYER_JUMP
  end
end

function Player:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["player"], math.floor(self.x), math.floor(self.y))
end
