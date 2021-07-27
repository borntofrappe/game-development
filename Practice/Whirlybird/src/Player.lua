Player = {}

local ANIMATION_INTERVAL = 0.1

function Player:new(x, y, direction, type)
  local direction = direction or 1
  local type = type or "default"

  local data = PLAYER.data[PLAYER.types[type]]
  local width = data.width
  local height = data.height
  local varieties = data.varieties

  local this = {
    ["type"] = type,
    ["variety"] = 1,
    ["varieties"] = varieties,
    ["timer"] = 0,
    ["x"] = x - width / 2,
    ["y"] = y - height / 2,
    ["width"] = width,
    ["height"] = height,
    ["dx"] = 0,
    ["dy"] = 0,
    ["direction"] = 1
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if self.type == "default" or self.type == "flying" then
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
  end

  self.dx = math.max(0, self.dx - FRICTION * dt)
  self.x = self.x + self.dx * self.direction

  if self.x < -self.width then
    self.x = WINDOW_WIDTH
  end

  if self.x > WINDOW_WIDTH then
    self.x = -self.width
  end

  if #self.varieties > 1 then
    self.timer = self.timer + dt
    if self.timer >= ANIMATION_INTERVAL then
      self.timer = self.timer % ANIMATION_INTERVAL
      self.variety = self.variety == #self.varieties and 1 or self.variety + 1
    end
  end
end

function Player:bounce()
  self.dy = JUMP * -1
end

function Player:slide(direction)
  self.dx = SLIDE
  self.direction = direction == "right" and 1 or -1
end

function Player:change(type)
  local data = PLAYER.data[PLAYER.types[type]]
  local width = data.width
  local height = data.height
  local varieties = data.varieties

  self.type = type
  self.x = self.x + (self.width - width)
  self.y = self.y + (self.height - height)
  self.width = width
  self.height = height
  self.variety = 1
  self.varieties = varieties
end

function Player:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["player"][self.varieties[self.variety]],
    self.direction == 1 and math.floor(self.x) or math.floor(self.x) + self.width,
    math.floor(self.y),
    0,
    self.direction == 1 and 1 or -1,
    1
  )
end
