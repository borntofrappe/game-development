CollisionProjectile = {}

local COLLISION_DELAY = 0.3

function CollisionProjectile:new(x, y, type)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["type"] = type or 1,
    ["delay"] = COLLISION_DELAY,
    ["time"] = 0,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function CollisionProjectile:update(dt)
  if self.inPlay then
    self.time = self.time + dt
    if self.time >= self.delay then
      self.inPlay = false
    end
  end
end

function CollisionProjectile:render()
  if self.inPlay then
    love.graphics.draw(gTextures["spritesheet"], gFrames["collision-projectiles"][self.type], self.x, self.y)
  end
end
