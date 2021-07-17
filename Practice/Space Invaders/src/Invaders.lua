Invaders = {}

local INVADERS_GRID = {
  ["columns"] = 8,
  ["rows-per-type"] = {2, 2, 1}
}

function Invaders:new(delayMultiplier)
  local invaders = {}

  local rows = 0
  for i, row in pairs(INVADERS_GRID["rows-per-type"]) do
    rows = rows + row
  end

  for type = 1, INVADER_TYPES do
    local rowsType = INVADERS_GRID["rows-per-type"][type]
    for row = 1, rowsType do
      for column = 1, INVADERS_GRID.columns do
        local x = WINDOW_PADDING + (column - 1) * (INVADER_WIDTH + INVADER_WIDTH / 2)
        local y = WINDOW_PADDING + (rows - row) * (INVADER_HEIGHT + INVADER_HEIGHT / 2)
        table.insert(invaders, Invader:new(x, y, type))
      end
    end
    rows = rows - rowsType
  end

  local this = {
    ["invaders"] = invaders,
    ["direction"] = 1,
    ["delayMultiplier"] = delayMultiplier
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Invaders:update()
  local changesDirection = false

  for k, invader in pairs(self.invaders) do
    local x = invader.x + invader.width * self.direction
    if x > WINDOW_WIDTH - WINDOW_PADDING - invader.width or x < WINDOW_PADDING then
      changesDirection = true
      break
    end
  end

  if changesDirection then
    self.direction = self.direction * -1
  end

  for k, invader in pairs(self.invaders) do
    Timer:after(
      self.delayMultiplier * invader.type,
      function()
        if changesDirection then
          invader.y = invader.y + invader.height
        else
          invader.x = invader.x + invader.width * self.direction
        end
        invader.frame = invader.frame == 1 and 2 or 1
      end
    )
  end

  return changesDirection
end

function Invaders:render()
  love.graphics.setColor(1, 1, 1)
  for k, invader in pairs(self.invaders) do
    invader:render()
  end
end
