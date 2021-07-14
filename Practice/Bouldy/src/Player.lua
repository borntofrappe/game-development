Player = {}

local POSITION_DIRECTION = {
  ["up"] = {0.5, 0.2},
  ["right"] = {0.8, 0.5},
  ["down"] = {0.5, 0.8},
  ["left"] = {0.2, 0.5}
}

local ACCELERATION_DIRECTION = {
  ["up"] = {-150, 125, 150, 350},
  ["right"] = {-125, -150, -350, 150},
  ["down"] = {-150, -125, 150, -350},
  ["left"] = {125, -150, 350, 150}
}

function Player:new(maze)
  local column = math.random(maze.columns)
  local row = math.random(maze.rows)

  local size = CELL_SIZE
  local paddingPercentage = 0.25
  local padding = math.floor(size * paddingPercentage)
  local innerSize = size - padding * 2

  local dust = Dust:new()

  local this = {
    ["column"] = column,
    ["row"] = row,
    ["size"] = size,
    ["padding"] = padding,
    ["paddingPercentage"] = paddingPercentage,
    ["innerSize"] = innerSize,
    ["fill"] = {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    },
    ["dust"] = dust
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:animateMovement(direction)
  local x = (self.column - 1) * self.size + self.size * POSITION_DIRECTION[direction][1]
  local y = (self.row - 1) * self.size + self.size * POSITION_DIRECTION[direction][2]

  self.dust:emit(x, y, ACCELERATION_DIRECTION[direction])
end

function Player:update(dt)
  self.dust:update(dt)
end

function Player:setFill(fill)
  self.fill = fill
end

function Player:render()
  love.graphics.setColor(self.fill.r, self.fill.g, self.fill.b)

  self.dust:render()

  love.graphics.rectangle(
    "fill",
    (self.column - 1) * self.size + self.padding,
    (self.row - 1) * self.size + self.padding,
    self.innerSize,
    self.innerSize
  )
end
