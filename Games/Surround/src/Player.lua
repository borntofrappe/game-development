Player = {}
Player.__index = Player

function Player:new(column, row, color, keys)
  this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = CELL_SIZE,
    ["d"] = {
      ["c"] = 0,
      ["r"] = 0
    },
    ["trail"] = {},
    ["color"] = color or
      {
        ["r"] = COLORS.p1.r,
        ["g"] = COLORS.p1.g,
        ["b"] = COLORS.p1.b
      },
    ["keys"] = keys or
      {
        ["up"] = "w",
        ["right"] = "d",
        ["down"] = "s",
        ["left"] = "a"
      }
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  if love.keyboard.wasPressed(self.keys["up"]) and self.d.r == 0 then
    gSounds["turn"]:stop()
    gSounds["turn"]:play()
    self.d.c = 0
    self.d.r = -1
  elseif love.keyboard.wasPressed(self.keys["right"]) and self.d.c == 0 then
    gSounds["turn"]:stop()
    gSounds["turn"]:play()
    self.d.c = 1
    self.d.r = 0
  elseif love.keyboard.wasPressed(self.keys["down"]) and self.d.r == 0 then
    gSounds["turn"]:stop()
    gSounds["turn"]:play()
    self.d.c = 0
    self.d.r = 1
  elseif love.keyboard.wasPressed(self.keys["left"]) and self.d.c == 0 then
    gSounds["turn"]:stop()
    gSounds["turn"]:play()
    self.d.c = -1
    self.d.r = 0
  end
end

function Player:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, OPACITY)
  for i, tail in ipairs(self.trail) do
    love.graphics.rectangle("fill", (tail.column - 1) * self.size, (tail.row - 1) * self.size, self.size, self.size)
  end

  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle("fill", (self.column - 1) * self.size, (self.row - 1) * self.size, self.size, self.size)
end
