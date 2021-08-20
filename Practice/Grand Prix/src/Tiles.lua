Tiles = {}

function Tiles:new()
  local columns = COLUMNS * 2 + 1
  local rows = ROWS

  local tiles = {}
  local tilesBackground = 1
  local tilesEdge = 1

  local tileSize = TILE_SIZE.texture

  for column = 1, columns do
    for row = 1, rows do
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local id = 2
      if row == 1 or row == rows then
        id = 1
      elseif row == 2 or row == rows - 1 then
        id = 4
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
