Debris = {}

local TEXTURE = love.graphics.newImage("res/graphics/debris.png")
local WIDTH = TEXTURE:getWidth()
local HEIGHT = TEXTURE:getHeight()

local SPEED = 40

function Debris:new()
  local x = math.random(2) == 1 and -WIDTH or VIRTUAL_WIDTH
  local y = math.random() * (VIRTUAL_HEIGHT + HEIGHT) - HEIGHT / 2
  local dx = SPEED

  if x == VIRTUAL_WIDTH then
    dx = dx * -1
  end

  local this = {
    ["image"] = TEXTURE,
    ["x"] = x,
    ["y"] = y,
    ["width"] = WIDTH,
    ["height"] = HEIGHT,
    ["dx"] = dx
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Debris:update(dt)
  self.x = self.x + self.dx * dt
end

function Debris:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
