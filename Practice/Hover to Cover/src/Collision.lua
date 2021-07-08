Collision = {}

local TEXTURE = love.graphics.newImage("res/graphics/collision.png")
local WIDTH = TEXTURE:getWidth()
local HEIGHT = TEXTURE:getHeight()

function Collision:new(x, y)
  local this = {
    ["image"] = TEXTURE,
    ["x"] = x - WIDTH / 2,
    ["y"] = y - HEIGHT / 2,
    ["width"] = WIDTH,
    ["height"] = HEIGHT
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Collision:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
