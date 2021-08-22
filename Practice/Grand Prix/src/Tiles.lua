Tiles = {}

-- build a grid from the textures introduced in constants.lua
function Tiles:new(type)
  local type = type or "default"
  local texture = TEXTURES[type]
  local tileSize = TEXTURE_SIZE

  local columns = texture:gsub(" ", ""):find("\n") - 1
  local _, rows = texture:gsub("\n", "")

  local tiles = {}
  texture = texture:gsub("[\n ]", "")

  for column = 1, columns do
    for row = 1, rows do
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local index = column + (row - 1) * columns
      local id = tonumber(texture:sub(index, index))

      local tile = Tile:new(x, y, id)
      table.insert(tiles, tile)
    end
  end

  if type == "default" then
    for column = 1, columns do
      for row = 1, rows do
        local x = (columns + column - 1) * tileSize
        local y = (row - 1) * tileSize
        local index = column + (row - 1) * columns
        local id = tonumber(texture:sub(index, index))

        local tile = Tile:new(x, y, id)
        table.insert(tiles, tile)
      end
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
