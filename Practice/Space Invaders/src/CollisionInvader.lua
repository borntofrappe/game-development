CollisionInvader = {}

local COLLISION_DELAY = 0.3

function CollisionInvader:new(x, y)
  local this = {
    ["x"] = x - COLLISION_INVADER_WIDTH / 2,
    ["y"] = y - COLLISION_INVADER_HEIGHT / 2,
    ["delay"] = COLLISION_DELAY,
    ["time"] = 0,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function CollisionInvader:update(dt)
  self.time = self.time + dt
  if self.time >= self.delay then
    self.inPlay = false
  end
end

function CollisionInvader:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["collision-invader"], self.x, self.y)
end
