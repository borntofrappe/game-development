Player = {}
Player.__index = Player

function Player:create(x, y)
  local sprite = 2
  local angle = 45
  local velocity = 30

  local offsetHeight = gTextures["cannon"]:getHeight()
  local offsetWidth = gTextures["cannon"]:getWidth() / #gQuads["cannon"]

  local isDestroyed = false

  this = {
    x = x,
    y = y,
    angle = angle,
    velocity = velocity,
    sprite = sprite,
    isDestroyed = isDestroyed,
    offsetHeight = offsetHeight,
    offsetWidth = offsetWidth
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if love.keyboard.isDown("up") then
    self.angle = math.max(0, self.angle - dt * UPDATE_SPEED)
  elseif love.keyboard.isDown("down") then
    self.angle = math.min(90, self.angle + dt * UPDATE_SPEED)
  end

  if love.keyboard.isDown("right") then
    self.velocity = math.min(100, self.velocity + dt * UPDATE_SPEED)
  elseif love.keyboard.isDown("left") then
    self.velocity = math.max(10, self.velocity - dt * UPDATE_SPEED)
  end

  if love.keyboard.wasPressed("d") then
    self.isDestroyed = not self.isDestroyed
  end
end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  if self.isDestroyed then
    love.graphics.draw(
      gTextures["gameover"],
      self.x + self.offsetWidth / 2 - gTextures["gameover"]:getWidth() / 2,
      self.y - gTextures["gameover"]:getHeight()
    )
  else
    love.graphics.draw(
      gTextures["cannon"],
      gQuads["cannon"][self.sprite],
      self.x + self.offsetWidth / 2,
      self.y - 18,
      math.rad(self.angle),
      1,
      1,
      self.offsetWidth / 2,
      self.offsetHeight - 18
    )
    love.graphics.draw(gTextures["cannon"], gQuads["cannon"][1], self.x, self.y - self.offsetHeight)
  end
end
