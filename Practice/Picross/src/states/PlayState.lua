PlayState = BaseState:new()

local OVERLAY_TWEEN = 0.1

function PlayState:enter()
  self.tools = Tools:new("pen")

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

  self.data = Data:new(self.index)

  Timer:every(
    self.interval.duration,
    function()
      self.data.timer.time = self.data.timer.time + 1
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

    if self.tools.selection == "pen" then
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
              ["data"] = self.data
            }
          )
        end
      end
    elseif self.tools.selection == "eraser" then
      if self.level.grid[index].value == "o" then
        self.level.grid[index].value = nil

        if self:checkVictory() then
          Timer:remove(self.interval.label)
          gStateMachine:change(
            "victory",
            {
              ["offset"] = self.offset,
              ["level"] = self.level,
              ["data"] = self.data
            }
          )
        end
      else
        self.level.grid[index].value = "x"
      end
    end
  end

  if love.keyboard.waspressed("space") or love.keyboard.waspressed("t") or love.keyboard.waspressed("x") then
    local currentSelection = self.tools.selection
    local newSelection = currentSelection == "pen" and "eraser" or "pen"
    self.tools:select(newSelection)

    Timer:tween(
      0.2,
      {
        [self.tools[currentSelection]] = {["scale"] = 0.7},
        [self.tools[newSelection]] = {["scale"] = 1}
      }
    )
  end

  if love.keyboard.waspressed("p") and self.tools.selection == "eraser" then
    self.tools:select("pen")

    Timer:tween(
      0.2,
      {
        [self.tools.eraser] = {["scale"] = 0.7},
        [self.tools.pen] = {["scale"] = 1}
      }
    )
  end

  if love.keyboard.waspressed("e") and self.tools.selection == "pen" then
    self.tools:select("eraser")

    Timer:tween(
      0.2,
      {
        [self.tools.pen] = {["scale"] = 0.7},
        [self.tools.eraser] = {["scale"] = 1}
      }
    )
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
  self.data:render()
  self.tools:render()

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
