Car = {}

local ANIMATION_INTERVAL = 0.1

function Car:new(x, y, color)
  local size = CAR_SIZE

  local frames = {}
  for i = 1, #gQuads.cars[color] do
    table.insert(frames, i)
  end

  local animation = Animation:new(frames, ANIMATION_INTERVAL)

  local this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = size,
    ["color"] = color,
    ["animation"] = animation
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Car:collides(car)
  if self.x + self.size < car.x or self.x > car.x + car.size or self.y + self.size < car.y or self.y > car.y + car.size then
    return false
  end

  return true
end

function Car:update(dt)
  self.animation:update(dt)
end

function Car:render()
  love.graphics.draw(
    gTextures["spritesheet"],
    gQuads["cars"][self.color][self.animation:getCurrentFrame()],
    self.x,
    self.y
  )
end
