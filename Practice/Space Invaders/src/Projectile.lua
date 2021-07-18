Projectile = {}

local PROJECTILE_SPEED = 300

function Projectile:new(x, y, direction)
  local this = {
    ["x"] = x - PROJECTILE_WIDTH / 2,
    ["y"] = y - PROJECTILE_HEIGHT / 2,
    ["width"] = PROJECTILE_WIDTH,
    ["height"] = PROJECTILE_HEIGHT,
    ["dy"] = direction == "down" and PROJECTILE_SPEED or PROJECTILE_SPEED * -1,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Projectile:update(dt)
  self.y = self.y + self.dy * dt
  if self.y < -self.height or self.y > WINDOW_HEIGHT then
    self.inPlay = false
  end
end

function Projectile:render()
  if self.inPlay then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures["spritesheet"], gFrames["projectile"], self.x, self.y)
  end
end
