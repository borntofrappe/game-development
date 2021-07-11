Cell = {}

local CELL_SIZE = 20

function Cell:new()
  local this = {
    ["x"] = love.math.random(WINDOW_WIDTH),
    ["y"] = love.math.random(WINDOW_HEIGHT),
    ["size"] = CELL_SIZE,
    ["color"] = {
      ["r"] = 0.1,
      ["g"] = 0.1,
      ["b"] = 0.1
    }
  }
  self.__index = self
  setmetatable(this, self)
  return this
end

function Cell:setRandomColor()
  self.color.r = love.math.random()
  self.color.g = love.math.random()
  self.color.b = love.math.random()
end

function Cell:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end
