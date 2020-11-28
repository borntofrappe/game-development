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
      ["r"] = 0.62, -- 0.16
      ["g"] = 0, -- 0.83
      ["b"] = 1 -- 0.69
    }
  }

  setmetatable(this, self)

  return this
end

function Player:update(dt)
  Timer:update(dt)
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

function Player:move()
  Timer:every(
    INTERVAL,
    function()
      if self.d.c ~= 0 or self.d.r ~= 0 then
        local hasTrail = false
        local previousTail = {}
        for i, tail in ipairs(self.trail) do
          if tail.column == self.column and tail.row == self.row then
            hasTrail = true
            previousTail = tail
            break
          end
        end

        if not hasTrail then
          table.insert(
            self.trail,
            {
              ["column"] = self.column,
              ["row"] = self.row
            }
          )
        else
        end
      end

      self.column = self.column + self.d.c
      self.row = self.row + self.d.r
    end
  )
end
