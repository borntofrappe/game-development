--[[
  Appendage "class"
  - setting up a series of variables describing the position, size of the appendage
  - drawing the appendage through a square
]]
Appendage = {
  x = 0,
  y = 0,
  width = SNAKE_WIDTH,
  height = SNAKE_HEIGHT
}


function Appendage:init(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end


-- include the appendage as a slightly rounded square
function Appendage:render()
  love.graphics.setColor(0.224, 0.524, 0.604, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2)
end

