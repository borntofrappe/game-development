Particles = {}

local ANIMATION_INTERVAL = 0.1

function Particles:new(x, y)
  local this = {
    ["x"] = math.floor(x - PARTICLES.width / 2),
    ["y"] = math.floor(y - PARTICLES.height / 2),
    ["width"] = PARTICLES.width,
    ["height"] = PARTICLES.height,
    ["frame"] = 1,
    ["frames"] = PARTICLES.frames,
    ["timer"] = 0,
    ["inPlay"] = true
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Particles:update(dt)
  if self.inPlay then
    self.timer = self.timer + dt
    if self.timer >= ANIMATION_INTERVAL then
      if self.frame == self.frames then
        self.inPlay = false
      else
        self.timer = self.timer % ANIMATION_INTERVAL
        self.frame = self.frame + 1
      end
    end
  end
end

function Particles:render()
  if self.inPlay then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gTextures["spritesheet"], gFrames["particles"][self.frame], self.x, self.y)
  end
end
