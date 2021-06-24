Gamedata = {}

function Gamedata:new()
  local width = CELL_SIZE * GAME_DATA_COLUMNS
  local height = CELL_SIZE * ROWS

  local level = 1
  local score = 0
  local lines = 0

  local this = {
    ["level"] = level,
    ["score"] = score,
    ["lines"] = lines
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Gamedata:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)
end
