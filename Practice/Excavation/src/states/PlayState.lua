PlayState = BaseState:new()

function PlayState:new(numberGems)
  local camera = {
    ["x"] = 0,
    ["y"] = 0
  }

  local particleSystem = ParticleSystem:new()

  local offset = {
    ["x"] = 8,
    ["y"] = 32
  }

  local tiles = Tiles:new()
  local columns = tiles.columns
  local rows = tiles.rows
  local cellSize = tiles.cellSize

  local treasure = Treasure:new(numberGems, columns, rows, cellSize)

  local underlay = love.graphics.newSpriteBatch(gTextures.spritesheet)
  for column = 1, tiles.columns do
    for row = 1, tiles.rows do
      underlay:add(gQuads.tiles[1], (column - 1) * cellSize, (row - 1) * cellSize)
    end
  end

  local selection = {
    ["column"] = love.math.random(tiles.columns),
    ["row"] = love.math.random(tiles.rows)
  }

  local hammer = Tool:new(141, 32, 27, 34, "hammer", "fill")
  local pickaxe = Tool:new(141, 70, 27, 34, "pickaxe", "outline")

  local progressBar = ProgressBar:new(8, 8, 160, 16)

  local this = {
    ["camera"] = camera,
    ["particleSystem"] = particleSystem,
    ["offset"] = offset,
    ["underlay"] = underlay,
    ["treasure"] = treasure,
    ["tiles"] = tiles,
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
  self.particleSystem:update(dt)

  local x, y = push:toGame(love.mouse:getPosition())
  if
    x > self.offset.x and x < self.offset.x + self.tiles.columns * self.tiles.cellSize and y > self.offset.y and
      y < self.offset.y + self.tiles.rows * self.tiles.cellSize
   then
    local column = math.floor((x - self.offset.x) / self.tiles.cellSize) + 1
    local row = math.floor((y - self.offset.y) / self.tiles.cellSize) + 1
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
    self.selection.row = math.min(self.tiles.rows, self.selection.row + 1)
  end

  if love.keyboard.waspressed("right") then
    self.selection.column = math.min(self.tiles.columns, self.selection.column + 1)
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
      (love.mouse.waspressed(1) and x > self.offset.x and x < self.offset.x + self.tiles.columns * self.tiles.cellSize and
        y > self.offset.y and
        y < self.offset.y + self.tiles.rows * self.tiles.cellSize)
   then
    local column = self.selection.column
    local row = self.selection.row

    self.particleSystem:emit(
      self.offset.x + (column - 1) * self.tiles.cellSize + self.tiles.cellSize / 2,
      self.offset.y + (row - 1) * self.tiles.cellSize + self.tiles.cellSize / 2,
      self.hammer.type == "fill" and 1 or 0.5
    )

    local tile = self.tiles.grid[column][row]
    local tilesCoords = {}
    local c1 = math.max(1, column - 1)
    local c2 = math.min(self.tiles.columns, column + 1)
    local r1 = math.max(1, row - 1)
    local r2 = math.min(self.tiles.rows, row + 1)

    if self.hammer.type == "fill" then
      for c = c1, c2 do
        for r = r1, r2 do
          if self.tiles.grid[c][r].inPlay then
            table.insert(tilesCoords, {c, r})
            local d = math.abs(c - column) + math.abs(r - row)
            if d <= 1 then
              table.insert(tilesCoords, {c, r})
            end
          end
        end
      end
    else
      table.insert(tilesCoords, {column, row})
      if self.tiles.grid[column][row].id < math.ceil(TILE_TYPES / 2) then
        table.insert(tilesCoords, {column, row})
      end

      for c = c1, c2 do
        for r = r1, r2 do
          local d = math.abs(c - column) + math.abs(r - row)
          if d == 1 and self.tiles.grid[c][r].inPlay then
            table.insert(tilesCoords, {c, r})
          end
        end
      end
    end

    for k, tileCoords in pairs(tilesCoords) do
      local c = tileCoords[1]
      local r = tileCoords[2]

      self.tiles.grid[c][r].id = math.max(1, self.tiles.grid[c][r].id - 1)
      if self.tiles.grid[c][r].id == 1 then
        self.tiles.grid[c][r].inPlay = false
      end
    end

    for k, gem in pairs(self.treasure.gems) do
      if not gem.dugUp then
        local inPlay = false
        for c = gem.column, gem.column + (gem.size - 1) do
          for r = gem.row, gem.row + (gem.size - 1) do
            if self.tiles.grid[c][r].inPlay then
              inPlay = true
              break
            end
          end
        end

        if not inPlay then
          gem.dugUp = true
          break
        end
      end
    end

    local allDugUp = true

    for k, gem in pairs(self.treasure.gems) do
      if not gem.dugUp then
        allDugUp = false
        break
      end
    end

    if allDugUp then
      local chunks = {"Everything was dug up!\n"}

      for i, gem in pairs(self.treasure.gems) do
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

    local progressAmount = self.hammer.type == "fill" and 1 or 0.5
    local wallCollapsed = self.progressBar:increase(progressAmount)

    if not allDugUp and wallCollapsed then
      local chunks = {"The wall collapsed!\n"}
      for k, gem in pairs(self.treasure.gems) do
        if gem.dugUp then
          local size = gem.size
          local color = gem.color
          local chunk = "You obtained a " .. color .. " gem, size " .. size .. "!\n"
          table.insert(chunks, chunk)
        end
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
  love.graphics.translate(self.camera.x, self.camera.y)

  love.graphics.setColor(0.292, 0.222, 0.155)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  self.progressBar:render()

  self.hammer:render()
  self.pickaxe:render()

  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)

  love.graphics.draw(self.underlay)

  self.treasure:render()

  self.tiles:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTextures.spritesheet,
    gQuads.selection,
    (self.selection.column - 1) * self.tiles.cellSize,
    (self.selection.row - 1) * self.tiles.cellSize
  )

  love.graphics.pop()

  self.particleSystem:render()
end
