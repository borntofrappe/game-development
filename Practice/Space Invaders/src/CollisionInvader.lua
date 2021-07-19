CollisionInvader = {}

local COLLISION_DELAY = 0.3

function CollisionInvader:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["delay"] = COLLISION_DELAY,
    ["time"] = 0,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function CollisionInvader:update(dt)
  if self.inPlay then
    self.time = self.time + dt
    if self.time >= self.delay then
      self.inPlay = false
    end
  end
end

function CollisionInvader:render()
  if self.inPlay then
    love.graphics.draw(gTextures["spritesheet"], gFrames["collision-invader"], self.x, self.y)
  end
end
