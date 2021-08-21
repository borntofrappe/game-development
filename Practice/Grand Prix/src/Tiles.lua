Tiles = {}

function Tiles:new(columns, rows, ids)
  local columns = columns or COLUMNS * 2 + 1
  local rows = rows or ROWS
  local ids =
    ids or
    {
      ["inner"] = 1,
      ["outer"] = 2,
      ["outermost"] = 3
    }
  local tiles = {}

  local tileSize = TEXTURE_SIZE

  for column = 1, columns do
    for row = 1, rows do
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local id = ids.inner
      if row == 1 or row == rows then
        id = ids.outermost
      elseif row == 2 or row == rows - 1 then
        id = ids.outer
      end

      local tile = Tile:new(x, y, id)
      table.insert(tiles, tile)
    end
  end

  local this = {
    ["tiles"] = tiles
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Tiles:render()
  for k, tile in pairs(self.tiles) do
    tile:render()
  end
end
