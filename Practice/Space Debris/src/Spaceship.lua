Spaceship = {}

local TEXTURE = love.graphics.newImage("res/graphics/spaceship.png")
local WIDTH = TEXTURE:getWidth()
local HEIGHT = TEXTURE:getHeight()

local GRAVITY = 2
local THRUST = 0.1
local MERCY = 5

function Spaceship:new()
  local this = {
    ["image"] = TEXTURE,
    ["x"] = VIRTUAL_WIDTH / 2 - WIDTH / 2,
    ["y"] = VIRTUAL_HEIGHT / 2 - HEIGHT / 2,
    ["width"] = WIDTH,
    ["height"] = HEIGHT,
    ["dy"] = -THRUST,
    ["thruster"] = Thruster:new()
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Spaceship:collides(debris)
  if self.x + MERCY > debris.x + debris.width or self.x + self.width - MERCY < debris.x then
    return false
  end

  if self.y + MERCY > debris.y + debris.height or self.y + self.height - MERCY < debris.y then
    return false
  end

  local bottomHalf = self.y + self.height / 2 < debris.y
  local rightHalf = self.x + self.width / 2 < debris.x

  local dx = rightHalf and -50 or 50
  local dy = bottomHalf and -50 or 50

  if rightHalf and debris.dx < 0 or not rightHalf and debris.dx > 0 then
    dx = dx * 1.5
  end
  return self.x + self.width / 2, self.y + self.height / 2, dx, dy
end

function Spaceship:update(dt)
  self.y = self.y + self.dy
  self.dy = self.dy + GRAVITY * dt

  if self.y < math.floor(-self.height / 2) then
    self.y = math.floor(-self.height / 2)
    self.dy = 0
  end

  if self.y > math.floor(VIRTUAL_HEIGHT - self.height / 2) then
    self.y = math.floor(VIRTUAL_HEIGHT - self.height / 2)
    self.dy = 0
  end

  self.thruster:update(dt)
end

function Spaceship:thrust()
  self.dy = self.dy - THRUST
  self.thruster:emit(self.x + self.width / 2, self.y + self.height)
end

function Spaceship:render()
  self.thruster:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
