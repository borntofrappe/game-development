Player = {}
Player.__index = Player

function Player:new(column, row)
  this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = CELL_SIZE,
    ["d"] = {
      ["c"] = 1,
      ["r"] = 0
    },
    ["trail"] = {},
    ["color"] = {
      ["r"] = 0.16, -- [0.62, 0.16]
      ["g"] = 0.83, -- [0, 0.83]
      ["b"] = 0.69 -- [1, 0.69]
    }
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if love.keyboard.wasPressed("up") then
    self.d.c = 0
    self.d.r = -1
  elseif love.keyboard.wasPressed("right") then
    self.d.c = 1
    self.d.r = 0
  elseif love.keyboard.wasPressed("down") then
    self.d.c = 0
    self.d.r = 1
  elseif love.keyboard.wasPressed("left") then
    self.d.c = -1
    self.d.r = 0
  end

  if love.keyboard.wasPressed("r") then
    self.trail = {}
  end
end

function Player:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 0.5)
  for i, tail in ipairs(self.trail) do
    love.graphics.rectangle("fill", (tail.column - 1) * self.size, (tail.row - 1) * self.size, self.size, self.size)
  end

  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
end
