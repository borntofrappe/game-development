Player = {}
Player.__index = Player

function Player:new(x, y)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = PLAYER_SIZE,
    ["d"] = {
      ["x"] = 1,
      ["y"] = 0
    },
    ["trail"] = {}
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
  love.graphics.setColor(0.5, 0.5, 0.5)
  for i, tail in ipairs(self.trail) do
    love.graphics.rectangle("fill", tail.x, tail.y, self.size, self.size)
  end

  love.graphics.setColor(0.25, 0.25, 0.25)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

function Player:move()
  Timer:every(
    INTERVAL,
    function()
      if self.d.x ~= 0 or self.d.y ~= 0 then
        table.insert(
          self.trail,
          {
            ["x"] = self.x,
            ["y"] = self.y
          }
        )
      end

      self.x = self.x + self.d.x * self.size
      self.y = self.y + self.d.y * self.size
    end
  )
end
