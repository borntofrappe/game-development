Cell = {}

function Cell:new(x, y, size, state, value)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["state"] = state,
    ["value"] = value
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Cell:render()
  if self.value == "o" then
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
  elseif self.value == "x" then
    love.graphics.setLineWidth(4)
    love.graphics.line(
      self.x + self.size / 4,
      self.y + self.size / 4,
      self.x + self.size * 3 / 4,
      self.y + self.size * 3 / 4
    )
    love.graphics.line(
      self.x + self.size / 4,
      self.y + self.size * 3 / 4,
      self.x + self.size * 3 / 4,
      self.y + self.size / 4
    )
  end
end
