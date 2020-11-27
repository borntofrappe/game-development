Player = {}
Player.__index = Player

function Player:new(x, y)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = PLAYER_SIZE,
    ["d"] = {
      ["x"] = 0,
      ["y"] = 0
    }
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  Timer:update(dt)
  if love.keyboard.wasPressed("up") then
    self.d.x = 0
    self.d.y = -1
  elseif love.keyboard.wasPressed("right") then
    self.d.x = 1
    self.d.y = 0
  elseif love.keyboard.wasPressed("down") then
    self.d.x = 0
    self.d.y = 1
  elseif love.keyboard.wasPressed("left") then
    self.d.x = -1
    self.d.y = 0
  end
end

function Player:render()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

function Player:move()
  Timer:every(
    INTERVAL,
    function()
      local x = self.x + self.d.x * self.size
      local y = self.y + self.d.y * self.size

      self.x = x
      self.y = y
    end
  )
end
