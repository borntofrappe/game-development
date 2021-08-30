PlayState = BaseState:new()

function PlayState:new(numberGems)
  local offsetGrid = {
    ["x"] = 8,
    ["y"] = 32
  }

  local grid = Grid:new()
  local tileSize = grid.tileSize
  local gridBackground = love.graphics.newSpriteBatch(gTextures.spritesheet, grid.columns * grid.rows)
  for column = 1, grid.columns do
    for row = 1, grid.rows do
      gridBackground:add(gQuads.textures[1], (column - 1) * tileSize, (row - 1) * tileSize)
    end
  end

  local selection = {
    ["column"] = love.math.random(grid.columns),
    ["row"] = love.math.random(grid.rows)
  }

  local hammer = Tool:new(141, 32, 27, 34, "hammer", "outline")
  local pickaxe = Tool:new(141, 70, 27, 34, "pickaxe", "fill")
  local progressBar = ProgressBar:new(8, 8, 160, 16)

  local this = {
    ["offsetGrid"] = offsetGrid,
    ["grid"] = grid,
    ["gridBackground"] = gridBackground,
    ["selection"] = selection,
    ["hammer"] = hammer,
    ["pickaxe"] = pickaxe,
    ["progressBar"] = progressBar
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
    self.selection.row = math.min(self.grid.rows, self.selection.row + 1)
  end

  if love.keyboard.waspressed("right") then
    self.selection.column = math.min(self.grid.columns, self.selection.column + 1)
  elseif love.keyboard.waspressed("left") then
    self.selection.column = math.max(1, self.selection.column - 1)
  end

  if love.keyboard.waspressed("return") then
    local column = self.selection.column
    local row = self.selection.row
    local tile = self.grid.tiles[column][row]
    if tile.inPlay then
      tile.id = tile.id - 1
      self.progressBar:increase()
      if tile.id == 1 then
        tile.inPlay = false
      end
    end
  end

  if love.keyboard.waspressed("r") then
    self.progressBar:reset()
  end

  if love.keyboard.waspressed("h") or love.keyboard.waspressed("H") then
    self.hammer:select()
    self.pickaxe:deselect()
  end

  if love.keyboard.waspressed("p") or love.keyboard.waspressed("P") then
    self.hammer:deselect()
    self.pickaxe:select()
  end
end

function PlayState:render()
  love.graphics.setColor(0.292, 0.222, 0.155)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  self.progressBar:render()

  self.hammer:render()
  self.pickaxe:render()

  love.graphics.push()
  love.graphics.translate(self.offsetGrid.x, self.offsetGrid.y)

  love.graphics.draw(self.gridBackground)
  self.grid:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures.spritesheet,
    gQuads.selection,
    (self.selection.column - 1) * self.grid.tileSize,
    (self.selection.row - 1) * self.grid.tileSize
  )

  love.graphics.pop()
end
