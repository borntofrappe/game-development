Player = {}
Player.__index = Player

function Player:create(x, y, aimsRight)
  local sprite = aimsRight and 2 or 3
  local angle = aimsRight and math.pi / 4 or -math.pi / 4

  local offsetHeight = gTextures["cannon"]:getHeight()
  local offsetWidth = gTextures["cannon"]:getWidth() / #gQuads["cannon"]

  this = {
    x = x,
    y = y,
    angle = angle,
    offsetHeight = offsetHeight,
    offsetWidth = offsetWidth,
    aimsRight = aimsRight,
    sprite = sprite
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if love.keyboard.isDown("up") then
    if self.aimsRight then
      self.angle = math.max(0, self.angle - dt)
    else
      self.angle = math.min(0, self.angle + dt)
    end
  elseif love.keyboard.isDown("down") then
    if self.aimsRight then
      self.angle = math.min(math.pi / 2, self.angle + dt)
    else
      self.angle = math.max(-math.pi / 2, self.angle - dt)
    end
  end
end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    gTextures["cannon"],
    gQuads["cannon"][self.sprite],
    self.x + self.offsetWidth / 2,
    self.y - 18,
    self.angle,
    1,
    1,
    self.offsetWidth / 2,
    self.offsetHeight - 18
  )
  love.graphics.draw(gTextures["cannon"], gQuads["cannon"][1], self.x, self.y - self.offsetHeight)
end
