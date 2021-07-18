CollisionPlayer = {}

local INTERVAL_DURATION = 0.5
local INTERVAL_ITERATIONS = 10

function CollisionPlayer:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["frame"] = 1,
    ["frames"] = COLLISION_PLAYER_FRAMES,
    ["time"] = 0,
    ["interval"] = INTERVAL_DURATION,
    ["iterations"] = INTERVAL_ITERATIONS,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function CollisionPlayer:update(dt)
  if self.inPlay then
    self.time = self.time + dt
    if self.time >= self.interval then
      self.time = self.time % self.interval

      if self.frame == self.frames then
        self.iterations = self.iterations - 1
        if self.iterations == 0 then
          self.inPlay = false
        end
        self.frame = 1
      else
        self.frame = self.frame + 1
      end
    end
  end
end

function CollisionPlayer:render()
  if self.inPlay then
    love.graphics.draw(gTextures["spritesheet"], gFrames["collision-player"][self.frame], self.x, self.y)
  end
end
