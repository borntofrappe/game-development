PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.level = 1
  self.score = 0
  self.goal = 1500
  self.timer = 30

  self.x = VIRTUAL_WIDTH / 2 - 16
  self.y = VIRTUAL_HEIGHT / 2 - ROWS * TILE_HEIGHT / 2
  self.width = COLUMNS * TILE_WIDTH
  self.height = ROWS * TILE_HEIGHT

  self.board = Board(self.level, self.x, self.y)
  while not self:hasMatch() do
    self.board = Board(self.level, self.x, self.y)
  end

  self.isUpdating = false

  self.fadein = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.levelText = {
    ["x"] = 0,
    ["y"] = -VIRTUAL_HEIGHT / 2 - 40
  }
  self.isTweening = true

  Timer.tween(
    1,
    {
      [self.fadein] = {a = 0}
    }
  ):finish(
    function()
      Timer.tween(
        0.5,
        {
          [self.levelText] = {y = 0}
        }
      ):finish(
        function()
          Timer.after(
            1,
            function()
              Timer.tween(
                0.5,
                {
                  [self.levelText] = {y = VIRTUAL_HEIGHT / 2 + 40}
                }
              ):finish(
                function()
                  self.isTweening = false
                  self.board.selectedTile = {
                    x = math.random(COLUMNS),
                    y = math.random(ROWS)
                  }
                  self:updateBoard()

                  Timer.every(
                    1,
                    function()
                      gSounds["clock"]:play()
                      self.timer = self.timer - 1
                    end
                  )
                end
              )
            end
          )
        end
      )
    end
  )
end

function PlayState:update(dt)
  if not self.isTweening then
    if not self.isUpdating then
      if love.mouse.isDown(1) then
        local x, y = push:toGame(love.mouse.getPosition())
        if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
          tileX = math.floor((x - self.x) / TILE_WIDTH) + 1
          tileY = math.floor((y - self.y) / TILE_HEIGHT) + 1

          self.board.selectedTile = {
            x = tileX,
            y = tileY
          }

          if not self.board.highlightedTile then
            self.board.highlightedTile = {
              x = tileX,
              y = tileY
            }
          end
        end
      end

      if love.mouse.isReleased then
        if self.board.highlightedTile then
          tile1 = self.board.tiles[self.board.selectedTile.y][self.board.selectedTile.x]
          tile2 = self.board.tiles[self.board.highlightedTile.y][self.board.highlightedTile.x]

          if math.abs(tile1.x - tile2.x) + math.abs(tile1.y - tile2.y) == 1 then
            self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] =
              self.board.tiles[tile2.y][tile2.x],
              self.board.tiles[tile1.y][tile1.x]

            if self:updateMatches() then
              tempX, tempY = tile1.x, tile1.y

              Timer.tween(
                0.15,
                {
                  [tile1] = {x = tile2.x, y = tile2.y},
                  [tile2] = {x = tempX, y = tempY}
                }
              ):finish(
                function()
                  if self:updateMatches() then
                    self:updateBoard()
                  end
                end
              )
            else
              gSounds["error"]:play()
              self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] =
                self.board.tiles[tile2.y][tile2.x],
                self.board.tiles[tile1.y][tile1.x]
            end
          else
            gSounds["error"]:play()
          end

          self.board.highlightedTile = nil
        end
      end
    end

    if love.keyboard.waspressed("escape") then
      Timer.clear()
      gStateMachine:change("title")
    end

    if love.keyboard.waspressed("right") then
      if self.board.selectedTile.x < COLUMNS then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.x = self.board.selectedTile.x + 1
      end
    end

    if love.keyboard.waspressed("left") then
      if self.board.selectedTile.x > 1 then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.x = self.board.selectedTile.x - 1
      end
    end

    if love.keyboard.waspressed("up") then
      if self.board.selectedTile.y > 1 then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.y = self.board.selectedTile.y - 1
      end
    end

    if love.keyboard.waspressed("down") then
      if self.board.selectedTile.y < ROWS then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.y = self.board.selectedTile.y + 1
      end
    end

    if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
      if not self.isUpdating then
        if self.board.highlightedTile then
          tile1 = self.board.tiles[self.board.selectedTile.y][self.board.selectedTile.x]
          tile2 = self.board.tiles[self.board.highlightedTile.y][self.board.highlightedTile.x]

          if math.abs(tile1.x - tile2.x) + math.abs(tile1.y - tile2.y) == 1 then
            self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] =
              self.board.tiles[tile2.y][tile2.x],
              self.board.tiles[tile1.y][tile1.x]

            if self:updateMatches() then
              tempX, tempY = tile1.x, tile1.y

              Timer.tween(
                0.15,
                {
                  [tile1] = {x = tile2.x, y = tile2.y},
                  [tile2] = {x = tempX, y = tempY}
                }
              ):finish(
                function()
                  if self:updateMatches() then
                    self:updateBoard()
                  end
                end
              )
            else
              gSounds["error"]:play()
              self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] =
                self.board.tiles[tile2.y][tile2.x],
                self.board.tiles[tile1.y][tile1.x]
            end
          else
            gSounds["error"]:play()
          end

          self.board.highlightedTile = nil
        else
          self.board.highlightedTile = {
            x = self.board.selectedTile.x,
            y = self.board.selectedTile.y
          }
        end
      end
    end
  end

  if self.timer > 0 then
    Timer.update(dt)
  else
    gSounds["game-over"]:play()
    Timer.clear()
    gStateMachine:change(
      "gameover",
      {
        score = self.score
      }
    )
  end
end

function PlayState:render()
  love.graphics.setColor(0.1, 0.17, 0.35, 0.7)
  love.graphics.rectangle("fill", 16, 16, 192, 140, 8)
  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle("fill", 16, 16, 192, 140, 8)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Level: " .. self.level, 17, 27, 192, "center")
  love.graphics.printf("Score: " .. self.score, 17, 59, 192, "center")
  love.graphics.printf("Goal: " .. self.goal, 17, 91, 192, "center")
  love.graphics.printf("Timer: " .. self.timer, 17, 123, 192, "center")

  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  love.graphics.printf("Level: " .. self.level, 16, 26, 192, "center")
  love.graphics.printf("Score: " .. self.score, 16, 58, 192, "center")
  love.graphics.printf("Goal: " .. self.goal, 16, 90, 192, "center")
  love.graphics.printf("Timer: " .. self.timer, 16, 122, 192, "center")

  self.board:render()

  if self.isTweening then
    love.graphics.setColor(self.fadein["r"], self.fadein["g"], self.fadein["b"], self.fadein["a"])
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.translate(self.levelText.x, self.levelText.y)
    love.graphics.setColor(0.42, 0.59, 0.94, 1)
    love.graphics.rectangle("fill", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 40)
    love.graphics.setFont(gFonts["medium"])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Level " .. self.level, 0, VIRTUAL_HEIGHT / 2 - 14, VIRTUAL_WIDTH, "center")
  end
end

function PlayState:updateMatches()
  local matches = {}
  for y = 1, ROWS do
    local color = nil
    local colorMatches = 1
    for x = 1, COLUMNS do
      if color == self.board.tiles[y][x].color then
        colorMatches = colorMatches + 1
      else
        if colorMatches >= 3 then
          local hasShiny = false
          local match = {}
          for x2 = x - 1, x - colorMatches, -1 do
            local tile = self.board.tiles[y][x2]
            if tile.isShiny then
              hasShiny = true
              break
            end

            table.insert(match, tile)
          end
          if hasShiny then
            match = {}
            for x3 = 1, COLUMNS do
              table.insert(match, self.board.tiles[y][x3])
            end
            table.insert(matches, match)

            break
          else
            table.insert(matches, match)
          end
        end

        color = self.board.tiles[y][x].color
        colorMatches = 1

        if x > COLUMNS - 2 then
          break
        end
      end
    end
    if colorMatches >= 3 then
      local hasShiny = false
      local match = {}
      for x = COLUMNS, COLUMNS - (colorMatches - 1), -1 do
        local tile = self.board.tiles[y][x]
        if tile.isShiny then
          hasShiny = true

          break
        end

        table.insert(match, tile)
      end
      if hasShiny then
        match = {}
        for x = 1, COLUMNS do
          table.insert(match, self.board.tiles[y][x])
        end
      end
      table.insert(matches, match)
    end
  end

  for x = 1, COLUMNS do
    local color = nil
    local colorMatches = 1
    for y = 1, ROWS do
      if color == self.board.tiles[y][x].color then
        colorMatches = colorMatches + 1
      else
        if colorMatches >= 3 then
          local match = {}
          for y2 = y - 1, y - colorMatches, -1 do
            local tile = self.board.tiles[y2][x]
            if tile.isShiny then
              for x2 = 1, COLUMNS do
                table.insert(match, self.board.tiles[y2][x2])
              end
            end

            table.insert(match, tile)
          end
          table.insert(matches, match)
        end

        color = self.board.tiles[y][x].color
        colorMatches = 1

        if y > ROWS - 2 then
          break
        end
      end
    end
    if colorMatches >= 3 then
      local match = {}
      for y = ROWS, ROWS - (colorMatches - 1), -1 do
        local tile = self.board.tiles[y][x]
        if tile.isShiny then
          for x2 = 1, COLUMNS do
            table.insert(match, self.board.tiles[y][x2])
          end
        end

        table.insert(match, tile)
      end
      table.insert(matches, match)
    end
  end

  self.board.matches = matches
  return #matches > 0
end

function PlayState:removeMatches()
  for k, match in pairs(self.board.matches) do
    self.timer = self.timer + #match
    for j, tile in pairs(match) do
      self.score = self.score + 100 * tile.variety
      self.board.tiles[tile.y][tile.x] = nil
    end
    if self.score >= self.goal then
      gSounds["next-level"]:play()

      self.level = self.level + 1
      self.goal = math.floor(self.goal * 2.15)

      self.isTweening = true
      self.levelText.y = -VIRTUAL_HEIGHT / 2 + 40
      Timer.tween(
        0.5,
        {
          [self.levelText] = {y = 0}
        }
      ):finish(
        function()
          Timer.after(
            1,
            function()
              Timer.tween(
                0.5,
                {
                  [self.levelText] = {y = VIRTUAL_HEIGHT / 2 + 40}
                }
              ):finish(
                function()
                  self.isTweening = false
                end
              )
            end
          )
        end
      )
    end
  end

  self.board.matches = {}
end

function PlayState:updateTiles()
  for x = 1, COLUMNS do
    local yNil = nil
    local y = ROWS
    while y > 0 do
      if yNil then
        if self.board.tiles[y][x] then
          self.board.tiles[yNil][x] = self.board.tiles[y][x]
          Timer.tween(
            0.2,
            {
              [self.board.tiles[yNil][x]] = {y = yNil}
            }
          )
          self.board.tiles[y][x] = nil
          y = yNil
          yNil = nil
        end
      else
        if not self.board.tiles[y][x] then
          yNil = y
        end
      end

      y = y - 1
    end
  end

  Timer.after(
    0.2,
    function()
      for x = 1, COLUMNS do
        for y = ROWS, 1, -1 do
          if not self.board.tiles[y][x] then
            local tile = Tile(x, y, self.level)
            self.board.tiles[y][x] = tile
            self.board.tiles[y][x].y = -1
            Timer.tween(
              0.2,
              {
                [self.board.tiles[y][x]] = {y = y}
              }
            )
          end
        end
      end
    end
  )
end

function PlayState:updateBoard()
  if self:updateMatches() then
    gSounds["match"]:stop()
    gSounds["match"]:play()
    self.isUpdating = true
    self:removeMatches()
    self:updateTiles()

    Timer.after(
      0.5,
      function()
        self:updateBoard()
      end
    )
  else
    self.isUpdating = false
  end
end

function PlayState:hasMatch()
  for y = 1, ROWS - 1 do
    for x = 1, COLUMNS - 1 do
      local tile = self.board.tiles[y][x]
      local neighbor1 = self.board.tiles[y][x + 1]

      self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor1.y][neighbor1.x] =
        self.board.tiles[neighbor1.y][neighbor1.x],
        self.board.tiles[tile.y][tile.x]
      if self:updateMatches() then
        self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor1.y][neighbor1.x] =
          self.board.tiles[neighbor1.y][neighbor1.x],
          self.board.tiles[tile.y][tile.x]
        return true
      else
        self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor1.y][neighbor1.x] =
          self.board.tiles[neighbor1.y][neighbor1.x],
          self.board.tiles[tile.y][tile.x]
      end

      local neighbor2 = self.board.tiles[y + 1][x]
      self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor2.y][neighbor2.x] =
        self.board.tiles[neighbor2.y][neighbor2.x],
        self.board.tiles[tile.y][tile.x]

      if self:updateMatches() then
        self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor2.y][neighbor2.x] =
          self.board.tiles[neighbor2.y][neighbor2.x],
          self.board.tiles[tile.y][tile.x]
        return true
      else
        self.board.tiles[tile.y][tile.x], self.board.tiles[neighbor2.y][neighbor2.x] =
          self.board.tiles[neighbor2.y][neighbor2.x],
          self.board.tiles[tile.y][tile.x]
      end
    end
  end

  return false
end
