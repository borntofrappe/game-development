Player = {}
Player.__index = Player

function Player:new()
  local y = love.math.random(math.floor(WINDOW_HEIGHT / 2), WINDOW_HEIGHT)

  local this = {
    ["x"] = 40,
    ["y"] = y,
    ["r"] = 12,
    ["velocity"] = 50,
    ["angle"] = 30
  }

  this.projectile = {
    ["x"] = this.x,
    ["y"] = this.y,
    ["r"] = this.r
  }

  setmetatable(this, self)
  return this
end

function Player:render()
  love.graphics.setColor(0.49, 0.85, 0.79)
  love.graphics.circle("fill", self.projectile.x, self.projectile.y, self.projectile.r)

  love.graphics.setColor(0.83, 0.87, 0.92)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
