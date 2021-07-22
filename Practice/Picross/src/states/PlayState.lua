PlayState = BaseState:new()

local OVERLAY_TWEEN = 0.1

function PlayState:enter()
  self.tool = "pen" -- [pen-eraser]

  self.pen = {
    ["x"] = WINDOW_WIDTH / 4 + 19,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = 25
  }

  self.eraser = {
    ["x"] = self.pen.x - 38,
    ["y"] = self.pen.y + 38,
    ["r"] = 25
  }

  self.offset = {
    ["x"] = WINDOW_WIDTH - GRID_SIZE - GRID_PADDING.x,
    ["y"] = WINDOW_HEIGHT - GRID_SIZE - GRID_PADDING.y
  }

  self.index = math.random(#LEVELS)
  self.level = Level:new(self.index)
  self.highlightedCell = {
    ["column"] = math.random(self.level.dimension),
    ["row"] = math.random(self.level.dimension),
    ["size"] = self.level.cellSize
  }

  self.overlay = {
    ["opacity"] = 1
  }

  self.interval = {
    ["duration"] = 1,
    ["label"] = "timer"
  }

  self.levelData = LevelData:new(self.index)

  Timer:every(
    self.interval.duration,
    function()
      self.levelData.timer.time = self.levelData.timer.time + 1
    end,
    false,
    self.interval.label
  )

  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    }
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:remove(self.interval.label)
    Timer:tween(
      OVERLAY_TWEEN,
      {
        [self.overlay] = {["opacity"] = 1}
      },
      function()
        gStateMachine:change("title")
      end
    )
  end

  if love.keyboard.waspressed("return") then
    local column = self.highlightedCell.column
    local row = self.highlightedCell.row
    local index = column + (row - 1) * self.level.dimension

    if self.tool == "pen" then
      if self.level.grid[index].value == "x" then
        self.level.grid[index].value = nil
      else
        self.level.grid[index].value = "o"

        if self:checkVictory() then
          Timer:remove(self.interval.label)
          gStateMachine:change(
            "victory",
            {
              ["offset"] = self.offset,
              ["level"] = self.level,
              ["levelData"] = self.levelData
            }
          )
        end
      end
    elseif self.tool == "eraser" then
      if self.level.grid[index].value == "o" then
        self.level.grid[index].value = nil

        if self:checkVictory() then
          Timer:remove(self.interval.label)
          gStateMachine:change(
            "victory",
            {
              ["offset"] = self.offset,
              ["level"] = self.level,
              ["levelData"] = self.levelData
            }
          )
        end
      else
        self.level.grid[index].value = "x"
      end
    end
  end

  if love.keyboard.waspressed("space") or love.keyboard.waspressed("t") or love.keyboard.waspressed("x") then
    self.tool = self.tool == "pen" and "eraser" or "pen"
  end

  if love.keyboard.waspressed("p") then
    self.tool = "pen"
  end

  if love.keyboard.waspressed("e") then
    self.tool = "eraser"
  end

  if love.keyboard.waspressed("up") and self.highlightedCell.row > 1 then
    self.highlightedCell.row = self.highlightedCell.row - 1
  end

  if love.keyboard.waspressed("right") and self.highlightedCell.column < self.level.dimension then
    self.highlightedCell.column = self.highlightedCell.column + 1
  end

  if love.keyboard.waspressed("down") and self.highlightedCell.row < self.level.dimension then
    self.highlightedCell.row = self.highlightedCell.row + 1
  end

  if love.keyboard.waspressed("left") and self.highlightedCell.column > 1 then
    self.highlightedCell.column = self.highlightedCell.column - 1
  end
end

function PlayState:checkVictory()
  for k, cell in pairs(self.level.grid) do
    if cell.state == "o" and cell.value ~= cell.state then
      return false
    end
    if cell.value == "o" and cell.value ~= cell.state then
      return false
    end
  end

  return true
end

function PlayState:render()
  self.levelData:render()

  love.graphics.setLineWidth(3)
  love.graphics.push()
  love.graphics.translate(self.pen.x, self.pen.y)

  if self.tool == "eraser" then
    love.graphics.scale(0.7, 0.7)
    love.graphics.setColor(0.05, 0.05, 0.15, 0.15)
  else
    love.graphics.setColor(0.98, 0.85, 0.05)
  end
  love.graphics.circle("fill", 0, 0, self.pen.r)

  love.graphics.setColor(0.07, 0.07, 0.2)
  love.graphics.circle("line", 0, 0, self.pen.r)

  love.graphics.polygon("fill", 5, -10, -9, 4, -9, 9, -3, 9, 10, -5)

  love.graphics.pop()

  love.graphics.push()
  love.graphics.translate(self.eraser.x, self.eraser.y)

  if self.tool == "pen" then
    love.graphics.scale(0.7, 0.7)
    love.graphics.setColor(0.05, 0.05, 0.15, 0.15)
  else
    love.graphics.setColor(0.98, 0.85, 0.05)
  end
  love.graphics.circle("fill", 0, 0, self.eraser.r)

  love.graphics.setColor(0.07, 0.07, 0.2)
  love.graphics.circle("line", 0, 0, self.eraser.r)

  love.graphics.line(-6, -6, 6, 6)
  love.graphics.line(-6, 6, 6, -6)

  love.graphics.pop()

  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)

  self.level:render()

  if self.highlightedCell then
    love.graphics.setColor(0.05, 0.05, 0.15, 0.15)
    love.graphics.rectangle(
      "fill",
      self.highlightedCell.size * #self.level.hints.rows[self.highlightedCell.row] * -1,
      (self.highlightedCell.row - 1) * self.highlightedCell.size,
      self.highlightedCell.size * #self.level.hints.rows[self.highlightedCell.row],
      self.highlightedCell.size
    )

    love.graphics.rectangle(
      "fill",
      (self.highlightedCell.column - 1) * self.highlightedCell.size,
      self.highlightedCell.size * #self.level.hints.columns[self.highlightedCell.column] * -1,
      self.highlightedCell.size,
      self.highlightedCell.size * #self.level.hints.columns[self.highlightedCell.column]
    )

    love.graphics.rectangle(
      "fill",
      (self.highlightedCell.column - 1) * self.highlightedCell.size,
      (self.highlightedCell.row - 1) * self.highlightedCell.size,
      self.highlightedCell.size,
      self.highlightedCell.size
    )

    love.graphics.setColor(0.07, 0.07, 0.2)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle(
      "line",
      (self.highlightedCell.column - 1) * self.highlightedCell.size,
      (self.highlightedCell.row - 1) * self.highlightedCell.size,
      self.highlightedCell.size,
      self.highlightedCell.size
    )
  end

  love.graphics.pop()

  if self.overlay.opacity > 0 then
    love.graphics.setColor(1, 1, 1, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
