Hat = {}

local ANIMATION_INTERVAL = 0.1

function Hat:new(x, y)
  local this = {
    ["x"] = x - HAT.width / 2,
    ["y"] = y - HAT.height / 2,
    ["width"] = HAT.width,
    ["height"] = HAT.height,
    ["frame"] = 1,
    ["frames"] = HAT.frames,
    ["timer"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Hat:update(dt)
  self.timer = self.timer + dt
  if self.timer >= ANIMATION_INTERVAL then
    self.timer = self.timer % ANIMATION_INTERVAL
    self.frame = self.frame == self.frames and 1 or self.frame + 1
  end
end

function Hat:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["spritesheet"], gFrames["hat"][self.frame], self.x, self.y)
end
