Player = {}
Player.__index = Player

function Player:create(x, y)
  local offsetHeight = gTextures["cannon"]:getHeight()
  local offsetWidth = gTextures["cannon"]:getWidth() / #gQuads["cannon"]

  local angle = 0
  this = {
    x = x,
    y = y,
    offsetHeight = offsetHeight,
    offsetWidth = offsetWidth,
    angle = angle
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if love.keyboard.isDown("up") then
    self.angle = math.max(0, self.angle - dt)
  elseif love.keyboard.isDown("down") then
    self.angle = math.min(math.pi / 2, self.angle + dt)
  end
end

function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(
    gTextures["cannon"],
    gQuads["cannon"][2],
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
