Brick = {}

function Brick:new(x, y, frame)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["frame"] = frame
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Brick:render()
  love.graphics.draw(gTexture, gFrames[self.frame], self.x, self.y)
end
