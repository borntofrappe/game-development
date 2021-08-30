PlayState = BaseState:new()

function PlayState:new(numberGems)
  local offsetGrid = {
    ["x"] = 8,
    ["y"] = 32
  }

  local grid = Grid:new()
  local tileSize = grid.tileSize

  local gems = {}
  local gemCoords = {}
  local numberGems = numberGems or 3

  for i = 1, numberGems do
    local gemSize = GEM_SIZES[love.math.random(#GEM_SIZES)]
    local column, row

    while true do
      column = love.math.random(grid.columns - (gemSize - 1))
      row = love.math.random(grid.rows - (gemSize - 1))

      local canFit = true

      for c = column, column + (gemSize - 1) do
        for r = row, row + (gemSize - 1) do
          if gemCoords["c" .. c .. "r" .. r] then
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

    local x = (column - 1) * tileSize
    local y = (row - 1) * tileSize
    local gemColor = GEM_COLORS[love.math.random(#GEM_COLORS)]

    local gem = Gem:new(x, y, gemSize, gemColor)
    table.insert(gems, gem)

    for c = column, column + (gemSize - 1) do
      for r = row, row + (gemSize - 1) do
        gemCoords["c" .. c .. "r" .. r] = true
      end
    end
  end

  local gridBackground = love.graphics.newSpriteBatch(gTextures.spritesheet)
  for column = 1, grid.columns do
    for row = 1, grid.rows do
      gridBackground:add(gQuads.textures[1], (column - 1) * tileSize, (row - 1) * tileSize)
    end
  end

  local selection = {
    ["column"] = love.math.random(grid.columns),
    ["row"] = love.math.random(grid.rows)
  }

  local hammer = Tool:new(141, 32, 27, 34, "hammer", "fill")
  local pickaxe = Tool:new(141, 70, 27, 34, "pickaxe", "outline")
  local progressBar = ProgressBar:new(8, 8, 160, 16)

  local this = {
    ["offsetGrid"] = offsetGrid,
    ["grid"] = grid,
    ["gems"] = gems,
    ["gemCoords"] = gemCoords,
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
  local x, y = push:toGame(love.mouse:getPosition())
  if
    x > self.offsetGrid.x and x < self.offsetGrid.x + self.grid.columns * self.grid.tileSize and y > self.offsetGrid.y and
      y < self.offsetGrid.y + self.grid.rows * self.grid.tileSize
   then
    local column = math.floor((x - self.offsetGrid.x) / self.grid.tileSize) + 1
    local row = math.floor((y - self.offsetGrid.y) / self.grid.tileSize) + 1
    self.selection.column = column
    self.selection.row = row
  end

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

  if love.mouse.waspressed(1) then
    -- technically the x and y coordinates are already available from the top of love.update
    local x, y = push:toGame(love.mouse:getPosition())

    if
      x > self.hammer.panel.x and x < self.hammer.panel.x + self.hammer.panel.width and y > self.hammer.panel.y and
        y < self.hammer.panel.y + self.hammer.panel.height
     then
      self.hammer:select()
      self.pickaxe:deselect()
    end

    if
      x > self.pickaxe.panel.x and x < self.pickaxe.panel.x + self.pickaxe.panel.width and y > self.pickaxe.panel.y and
        y < self.pickaxe.panel.y + self.pickaxe.panel.height
     then
      self.pickaxe:select()
      self.hammer:deselect()
    end
  end

  if
    love.keyboard.waspressed("return") or
      (love.mouse.waspressed(1) and x > self.offsetGrid.x and
        x < self.offsetGrid.x + self.grid.columns * self.grid.tileSize and
        y > self.offsetGrid.y and
        y < self.offsetGrid.y + self.grid.rows * self.grid.tileSize)
   then
    local column = self.selection.column
    local row = self.selection.row

    self.progressBar:increase()

    local tilesCoords = {}

    local c1 = math.max(1, column - 1)
    local c2 = math.min(self.grid.columns, column + 1)

    local r1 = math.max(1, row - 1)
    local r2 = math.min(self.grid.rows, row + 1)

    for c = c1, c2 do
      table.insert(tilesCoords, {c, row})
    end

    for r = r1, r2 do
      table.insert(tilesCoords, {column, r})
    end

    for i, tileCoords in ipairs(tilesCoords) do
      local c = tileCoords[1]
      local r = tileCoords[2]

      local tile = self.grid.tiles[c][r]
      if tile.inPlay then
        tile.id = tile.id - 1
        if tile.id == 1 then
          tile.inPlay = false
        end
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

  -- debugging
  if love.keyboard.waspressed("g") then
    local collapsed = true
    if collapsed then
      local chunks = {"The wall collapsed!\n"}
      -- technically you'd highlight only the collected gems
      for i, gem in pairs(self.gems) do
        local size = gem.size
        local color = gem.color
        local chunk = "You obtained a " .. color .. " gem, size " .. size .. "!\n"
        table.insert(chunks, chunk)
      end

      gStateStack:push(
        TransitionState:new(
          {
            ["transitionStart"] = true,
            ["prevenDefault"] = true,
            ["callback"] = function()
              gStateStack:push(
                DialogueState:new(
                  {
                    ["chunks"] = chunks,
                    ["callback"] = function()
                      gStateStack:pop() -- remove preserved transition

                      gStateStack:push(TitleState:new())
                      gStateStack:push(
                        TransitionState:new(
                          {
                            ["transitionStart"] = false
                          }
                        )
                      )
                    end
                  }
                )
              )
            end
          }
        )
      )
    end
  end

  if love.keyboard.waspressed("w") then
    local allDugUp = true
    if allDugUp then
      local chunks = {"Everything was dug up!\n"}

      for i, gem in pairs(self.gems) do
        local size = gem.size
        local color = gem.color
        local chunk = "You obtained a " .. color .. " gem, size " .. size .. "!\n"
        table.insert(chunks, chunk)
      end

      gStateStack:push(
        DialogueState:new(
          {
            ["chunks"] = chunks,
            ["callback"] = function()
              gStateStack:push(
                TransitionState:new(
                  {
                    ["transitionStart"] = true,
                    ["callback"] = function()
                      gStateStack:pop()

                      local numberGems = love.math.random(GEMS_MAX)
                      gStateStack:push(PlayState:new(numberGems))
                      gStateStack:push(
                        DialogueState:new(
                          {
                            ["chunks"] = {"Something pinged in the wall!\n" .. numberGems .. " confirmed!"}
                          }
                        )
                      )
                      gStateStack:push(
                        TransitionState:new(
                          {
                            ["transitionStart"] = false
                          }
                        )
                      )
                    end
                  }
                )
              )
            end
          }
        )
      )
    end
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

  for i, gem in pairs(self.gems) do
    gem:render()
  end

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
