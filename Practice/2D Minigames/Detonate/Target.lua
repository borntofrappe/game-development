Target = {}

local SIZE = 24

function Target:new()
  local this = {
    ["x"] = WINDOW_WIDTH / 2 - SIZE / 2,
    ["y"] = WINDOW_HEIGHT / 4 - SIZE / 2,
    ["size"] = SIZE,
    ["inFocus"] = false
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Target:render()
  love.graphics.setColor(1, 1, 1)
  if self.inFocus then
    love.graphics.setColor(1, 0.1, 0.2)
  end

  love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
end
