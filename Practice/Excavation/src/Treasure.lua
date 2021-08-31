Treasure = {}

function Treasure:new(numberGems, columns, rows, cellSize)
  local gems = {}
  local coords = {}

  for i = 1, numberGems do
    local size = GEM_SIZES[love.math.random(#GEM_SIZES)]
    local column, row

    while true do
      column = love.math.random(columns - (size - 1))
      row = love.math.random(rows - (size - 1))

      local canFit = true

      for c = column, column + (size - 1) do
        for r = row, row + (size - 1) do
          if coords["c" .. c .. "r" .. r] then
            canFit = false
            break
          end
        end
        if not canFit then
          break
        end
      end

      if canFit then
        break
      end
    end

    local color = GEM_COLORS[love.math.random(#GEM_COLORS)]

    local gem = Gem:new(column, row, size, color)
    table.insert(gems, gem)

    for c = column, column + (size - 1) do
      for r = row, row + (size - 1) do
        coords["c" .. c .. "r" .. r] = true
      end
    end
  end

  local this = {
    ["gems"] = gems
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Treasure:render()
  for i, gem in pairs(self.gems) do
    gem:render()
  end
end
