Player = {}
Player.__index = Player

function Player:new(terrain)
  local y = terrain.points[2]

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
  love.graphics.circle("fill", self.projectile.x, self.projectile.y, self.projectile.r)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
