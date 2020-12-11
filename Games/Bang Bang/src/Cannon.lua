Cannon = {}
Cannon.__index = Cannon

function Cannon:create(x, y)
  local width = CANNON_WIDTH
  local height = CANNON_HEIGHT

  local sprite = 2
  local angle = love.math.random(math.floor(ANGLE_MAX / INCREMENT)) * INCREMENT
  local velocity = love.math.random(math.floor(VELOCITY_MAX / INCREMENT)) * INCREMENT

  local isDestroyed = false

  this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["angle"] = angle,
    ["velocity"] = velocity,
    ["sprite"] = sprite,
    ["isDestroyed"] = isDestroyed
  }

  setmetatable(this, self)

  return this
end

function Cannon:render()
  love.graphics.setColor(1, 1, 1, 1)
  if self.isDestroyed then
    love.graphics.draw(
      gTextures["gameover"],
      self.x + self.width / 2 - gTextures["gameover"]:getWidth() / 2,
      self.y - gTextures["gameover"]:getHeight()
    )
  else
    love.graphics.draw(
      gTextures["cannon"],
      gQuads["cannon"][self.sprite],
      self.x + self.width / 2,
      self.y - CANNON_OFFSET_HEIGHT,
      math.rad(ANGLE_MAX - self.angle),
      1,
      1,
      self.width / 2,
      self.height - CANNON_OFFSET_HEIGHT
    )
    love.graphics.draw(gTextures["cannon"], gQuads["cannon"][1], self.x, self.y - self.height)
  end
end
