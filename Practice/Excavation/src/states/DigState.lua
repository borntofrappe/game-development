DigState = BaseState:new()

function DigState:new(def)
  local this = {
    ["state"] = def.state
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function DigState:enter()
  self.state.camera.index = 1 -- reset camera shake

  local column = self.state.selection.column
  local row = self.state.selection.row

  self.state.particleSystem:emit(
    self.state.offset.x + (column - 1) * self.state.tiles.cellSize + self.state.tiles.cellSize / 2,
    self.state.offset.y + (row - 1) * self.state.tiles.cellSize + self.state.tiles.cellSize / 2,
    self.state.hammer.type == "fill" and 1 or 0.5
  )

  local tile = self.state.tiles.grid[column][row]
  local tilesCoords = {}
  local c1 = math.max(1, column - 1)
  local c2 = math.min(self.state.tiles.columns, column + 1)
  local r1 = math.max(1, row - 1)
  local r2 = math.min(self.state.tiles.rows, row + 1)

  if self.state.hammer.type == "fill" then
    for c = c1, c2 do
      for r = r1, r2 do
        if self.state.tiles.grid[c][r].inPlay then
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
    if self.state.tiles.grid[column][row].id < math.ceil(TILE_TYPES / 2) then
      table.insert(tilesCoords, {column, row})
    end

    for c = c1, c2 do
      for r = r1, r2 do
        local d = math.abs(c - column) + math.abs(r - row)
        if d == 1 and self.state.tiles.grid[c][r].inPlay then
          table.insert(tilesCoords, {c, r})
        end
      end
    end
  end

  for k, tileCoords in pairs(tilesCoords) do
    local c = tileCoords[1]
    local r = tileCoords[2]

    self.state.tiles.grid[c][r].id = math.max(1, self.state.tiles.grid[c][r].id - 1)
    if self.state.tiles.grid[c][r].id == 1 then
      self.state.tiles.grid[c][r].inPlay = false
    end
  end

  for k, gem in pairs(self.state.treasure.gems) do
    if not gem.dugUp then
      local inPlay = false
      for c = gem.column, gem.column + (gem.size - 1) do
        for r = gem.row, gem.row + (gem.size - 1) do
          if self.state.tiles.grid[c][r].inPlay then
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
  for k, gem in pairs(self.state.treasure.gems) do
    if not gem.dugUp then
      allDugUp = false
      break
    end
  end

  local progressAmount = self.state.hammer.type == "fill" and 1 or 0.5
  local wallCollapsed = self.state.progressBar:increase(progressAmount)

  Timer:every(
    self.state.camera.duration / #self.state.camera.offsets,
    function()
      if self.state.camera.index == #self.state.camera.offsets then
        Timer:reset()
        if allDugUp then
          local chunks = {"Everything was dug up!\n"}
          for i, gem in pairs(self.state.treasure.gems) do
            local size = love.math.random(GEM_SIZES_DUG_UP[gem.size][1], GEM_SIZES_DUG_UP[gem.size][2])
            local color = gem.color
            local chunk = "You obtained a " .. color .. " gem, size " .. size .. "!\n"
            table.insert(chunks, chunk)
          end

          Timer:after(
            1,
            function()
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
                              gStateStack:pop() -- dig state
                              gStateStack:pop() -- play state

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
          )
        elseif wallCollapsed then
          Timer:every(
            self.state.camera.duration / #self.state.camera.offsets,
            function()
              if self.state.camera.index == #self.state.camera.offsets then
                self.state.camera.index = 1
              else
                self.state.camera.index = self.state.camera.index + 1
              end
            end
          )

          local chunks = {"The wall collapsed!\n"}
          for k, gem in pairs(self.state.treasure.gems) do
            if gem.dugUp then
              local size = love.math.random(GEM_SIZES_DUG_UP[gem.size][1], GEM_SIZES_DUG_UP[gem.size][2])
              local color = gem.color
              local chunk = "You obtained a " .. color .. " gem, size " .. size .. "!\n"
              table.insert(chunks, chunk)
            end
          end

          Timer:after(
            1,
            function()
              gStateStack:push(
                TransitionState:new(
                  {
                    ["transitionStart"] = true,
                    ["prevenDefault"] = true,
                    ["callback"] = function()
                      Timer:reset()

                      gStateStack:push(
                        DialogueState:new(
                          {
                            ["chunks"] = chunks,
                            ["callback"] = function()
                              gStateStack:pop() -- preserved transition
                              gStateStack:pop() -- dig state
                              gStateStack:pop() -- play state

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
          )
        else
          gStateStack:pop()
        end
      else
        self.state.camera.index = self.state.camera.index + 1
      end
    end
  )
end

function DigState:update(dt)
  Timer:update(dt)
  self.state.particleSystem:update(dt)
end

function DigState:render()
  self.state:render()
end
