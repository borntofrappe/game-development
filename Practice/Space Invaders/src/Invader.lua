Invader = {}

function Invader:new(x, y, type)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = INVADER_WIDTH,
    ["height"] = INVADER_HEIGHT,
    ["type"] = type,
    ["frame"] = 1,
    ["points"] = type * INVADER_POINTS_MULTIPLIER
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Invader:render()
  love.graphics.draw(gTextures["spritesheet"], gFrames["invaders"][self.type][self.frame], self.x, self.y)
end
