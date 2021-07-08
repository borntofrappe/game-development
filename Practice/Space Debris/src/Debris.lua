Debris = {}

local TEXTURE = love.graphics.newImage("res/graphics/debris.png")
local WIDTH = TEXTURE:getWidth()
local HEIGHT = TEXTURE:getHeight()

local SPEED_MIN = 30
local SPEED_MAX = 60

function Debris:new(previousDebris)
  local x = math.random(2) == 1 and -WIDTH or VIRTUAL_WIDTH
  local y
  repeat
    y = math.random() * (VIRTUAL_HEIGHT + HEIGHT) - HEIGHT / 2
  until not previousDebris or y + HEIGHT < previousDebris.y or y > previousDebris.y + previousDebris.height

  local dx = math.random(SPEED_MIN, SPEED_MAX)

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
