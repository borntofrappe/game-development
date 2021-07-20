Projectile = {}

local PROJECTILE_SPEED = 300

function Projectile:new(x, y, direction)
  local dy = direction and PROJECTILE_SPEED * direction or PROJECTILE_SPEED * -1

  local this = {
    ["x"] = x - PROJECTILE_WIDTH / 2,
    ["y"] = y - PROJECTILE_HEIGHT / 2,
    ["width"] = PROJECTILE_WIDTH,
    ["height"] = PROJECTILE_HEIGHT,
    ["dy"] = dy,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Projectile:update(dt)
  self.y = self.y + self.dy * dt
  if self.y <= 0 or self.y >= WINDOW_HEIGHT - self.height then
    self.inPlay = false
  end
end

function Projectile:render()
  if self.inPlay then
    love.graphics.draw(gTextures["spritesheet"], gFrames["projectile"], self.x, self.y)
  end
end
