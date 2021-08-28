PlayState = BaseState:new()

local COLUMNS = 14
local ROWS = 10

local OFFSET_INCREMENT = 0.15 -- the lower the less varied the noise field
local OFFSET_START_MAX = 1000

function PlayState:new()
  local grid = {}
  local offsetStartColumn = love.math.random(OFFSET_START_MAX)
  local offsetStartRow = love.math.random(OFFSET_START_MAX)
  local offsetColumn = offsetStartColumn
  local offsetRow = offsetStartRow

  local xStart = 7
  local yStart = 32
  local tileSize = TILE_SIZE

  for row = 1, ROWS do
    offsetColumn = 0
    for column = 1, COLUMNS do
      offsetColumn = offsetColumn + OFFSET_INCREMENT
      local x = (column - 1) * tileSize
      local y = (row - 1) * tileSize
      local noise = love.math.noise(offsetColumn, offsetRow)
      local id = math.ceil(noise * (TEXTURE_TYPES - 1)) + 1

      local tile = Tile:new(x, y, id)
      table.insert(grid, tile)
    end
    offsetRow = offsetRow + OFFSET_INCREMENT
  end

  local selection = {
    ["column"] = love.math.random(COLUMNS),
    ["row"] = love.math.random(ROWS)
  }

  local this = {
    ["xStart"] = xStart,
    ["yStart"] = yStart,
    ["grid"] = grid,
    ["selection"] = selection
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateStack:pop()
    gStateStack:push(TitleState:new())
  end

  if love.keyboard.waspressed("up") then
    self.selection.row = math.max(1, self.selection.row - 1)
  elseif love.keyboard.waspressed("down") then
    self.selection.row = math.min(ROWS, self.selection.row + 1)
  end

  if love.keyboard.waspressed("right") then
    self.selection.column = math.min(COLUMNS, self.selection.column + 1)
  elseif love.keyboard.waspressed("left") then
    self.selection.column = math.max(1, self.selection.column - 1)
  end

  if love.keyboard.waspressed("return") then
    local column = self.selection.column
    local row = self.selection.row
    local index = column + (row - 1) * COLUMNS
    local tile = self.grid[index]
    if tile.id > 1 then
      tile.id = tile.id - 1
    end
  end
end

function PlayState:render()
  love.graphics.setColor(0.292, 0.222, 0.155)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.push()
  love.graphics.translate(self.xStart, self.yStart)

  love.graphics.setColor(1, 1, 1)

  for k, tile in pairs(self.grid) do
    tile:render()
  end

  love.graphics.draw(
    gTextures.spritesheet,
    gQuads.selection,
    (self.selection.column - 1) * TILE_SIZE,
    (self.selection.row - 1) * TILE_SIZE
  )
  love.graphics.pop()
end
