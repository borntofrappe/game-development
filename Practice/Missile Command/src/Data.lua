Data = {}

function Data:new()
  local backgroundHeight = gFonts.normal:getHeight()

  local background = {
    ["x"] = 0,
    ["y"] = WINDOW_HEIGHT - backgroundHeight,
    ["width"] = WINDOW_WIDTH,
    ["height"] = backgroundHeight
  }

  local this = {
    ["points"] = 0,
    ["lives"] = 3,
    ["background"] = background
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Data:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.background.x, self.background.y, self.background.width, self.background.height)

  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.print("P1\t" .. self.points, 8, self.background.y)
end
