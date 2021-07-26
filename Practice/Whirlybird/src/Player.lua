Player = {}

local ANIMATION_INTERVAL = 0.15

function Player:new(x, y, type)
  local type = type or "default"
  local data = PLAYER[PLAYER_TYPES[type]]
  local width = data.width
  local height = data.height
  local varieties = data.varieties

  local this = {
    ["x"] = x - width / 2,
    ["y"] = y - height / 2,
    ["width"] = width,
    ["height"] = height,
    ["variety"] = 1,
    ["varieties"] = varieties,
    ["timer"] = 0
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if #self.varieties > 1 then
    self.timer = self.timer + dt
    if self.timer >= ANIMATION_INTERVAL then
      self.timer = self.timer % ANIMATION_INTERVAL
      self.variety = self.variety == #self.varieties and 1 or self.variety + 1
    end
  end
end

function Player:change(type)
  local data = PLAYER[PLAYER_TYPES[type]]
  local width = data.width
  local height = data.height
  local varieties = data.varieties

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
    math.floor(self.x),
    math.floor(self.y)
  )
end
