PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.board = Board(VIRTUAL_WIDTH / 2 + 100)
  self.isUpdating = false

  self.level = 1
  self.score = 0
  self.goal = 5000
  self.timer = 60

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
    if love.keyboard.waspressed("escape") then
      Timer.clear()
      gStateMachine:change("title")
    end

    if love.keyboard.waspressed("right") then
      if self.board.selectedTile.x < COLUMNS then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.x = self.board.selectedTile.x + 1
      else
        gSounds["error"]:stop()
        gSounds["error"]:play()
      end
    end

    if love.keyboard.waspressed("left") then
      if self.board.selectedTile.x > 1 then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.x = self.board.selectedTile.x - 1
      else
        gSounds["error"]:stop()
        gSounds["error"]:play()
      end
    end

    if love.keyboard.waspressed("up") then
      if self.board.selectedTile.y > 1 then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.y = self.board.selectedTile.y - 1
      else
        gSounds["error"]:stop()
        gSounds["error"]:play()
      end
    end

    if love.keyboard.waspressed("down") then
      if self.board.selectedTile.y < ROWS then
        gSounds["select"]:stop()
        gSounds["select"]:play()

        self.board.selectedTile.y = self.board.selectedTile.y + 1
      else
        gSounds["error"]:stop()
        gSounds["error"]:play()
      end
    end

    if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
      if not self.isUpdating then
        if self.board.highlightedTile then
          tile1 = self.board.tiles[self.board.selectedTile.y][self.board.selectedTile.x]
          tile2 = self.board.tiles[self.board.highlightedTile.y][self.board.highlightedTile.x]

          if math.abs(tile1.x - tile2.x) + math.abs(tile1.y - tile2.y) == 1 then
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

            self.board.tiles[tile1.y][tile1.x], self.board.tiles[tile2.y][tile2.x] =
              self.board.tiles[tile2.y][tile2.x],
              self.board.tiles[tile1.y][tile1.x]
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
  love.graphics.rectangle("fill", 16, 16, 188, 140, 8)
  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.rectangle("fill", 16, 16, 188, 140, 8)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Level: " .. self.level, 17, 27, 188, "center")
  love.graphics.printf("Score: " .. self.score, 17, 59, 188, "center")
  love.graphics.printf("Goal: " .. self.goal, 17, 91, 188, "center")
  love.graphics.printf("Timer: " .. self.timer, 17, 123, 188, "center")

  love.graphics.setColor(0.42, 0.59, 0.94, 1)
  love.graphics.printf("Level: " .. self.level, 16, 26, 188, "center")
  love.graphics.printf("Score: " .. self.score, 16, 58, 188, "center")
  love.graphics.printf("Goal: " .. self.goal, 16, 90, 188, "center")
  love.graphics.printf("Timer: " .. self.timer, 16, 122, 188, "center")

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
          local match = {}
          for x2 = x - 1, x - colorMatches, -1 do
            table.insert(match, self.board.tiles[y][x2])
          end
          table.insert(matches, match)
        end

        color = self.board.tiles[y][x].color
        colorMatches = 1

        if x > COLUMNS - 2 then
          break
        end
      end
    end
    if colorMatches >= 3 then
      local match = {}
      for x = COLUMNS, COLUMNS - (colorMatches - 1), -1 do
        table.insert(match, self.board.tiles[y][x])
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
            table.insert(match, self.board.tiles[y2][x])
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
        table.insert(match, self.board.tiles[y][x])
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
      self.score = self.score + 50 * tile.variety
      self.board.tiles[tile.y][tile.x] = nil
    end
    if self.score > self.goal then
      gSounds["next-level"]:play()

      self.timer = self.timer + self.level * 10
      self.level = self.level + 1
      self.goal = math.floor(self.goal * 2.5)

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
            self.board.tiles[y][x] = Tile(x, y)
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
