PlayState = BaseState:new()

local TIMER_INTERVAL = 1

local TOOLS = {
  ["tween"] = 0.2,
  ["scales"] = {1, 0.7}
}

function PlayState:enter(params)
  self.overlay = {
    ["opacity"] = 1
  }

  self.offset = {
    ["x"] = WINDOW_WIDTH - GRID_SIZE - GRID_PADDING.x,
    ["y"] = WINDOW_HEIGHT - GRID_SIZE - GRID_PADDING.y
  }

  self.index = params.index
  self.level = Level:new(self.index)

  self.highlightedCell = {
    ["column"] = math.random(self.level.dimension),
    ["row"] = math.random(self.level.dimension),
    ["size"] = self.level.cellSize
  }

  self.data = Data:new(self.level)
  self.tools = Tools:new("pen")

  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    },
    function()
      Timer:every(
        TIMER_INTERVAL,
        function()
          self.data.timer.time = self.data.timer.time + 1
        end
      )
    end
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    if self.overlay.opacity == 0 then
      Timer:reset()
      Timer:tween(
        OVERLAY_TWEEN,
        {
          [self.overlay] = {["opacity"] = 1}
        },
        function()
          gStateMachine:change(
            "select",
            {
              ["index"] = self.index
            }
          )
        end
      )
    end
  end

  if love.keyboard.waspressed("return") then
    if self.overlay.opacity == 0 then
      local column = self.highlightedCell.column
      local row = self.highlightedCell.row
      local index = column + (row - 1) * self.level.dimension

      if self.tools.selection == "pen" then
        if self.level.grid[index].value == "x" then
          self.level.grid[index].value = nil
        else
          self.level.grid[index].value = "o"

          if self:checkVictory() then
            self:goToVictoryState()
          end
        end
      elseif self.tools.selection == "eraser" then
        if self.level.grid[index].value == "o" then
          self.level.grid[index].value = nil

          if self:checkVictory() then
            self:goToVictoryState()
          end
        else
          self.level.grid[index].value = "x"
        end
      end
    end
  end

  if love.keyboard.waspressed("space") or love.keyboard.waspressed("t") or love.keyboard.waspressed("x") then
    if self.overlay.opacity == 0 then
      local currentSelection = self.tools.selection
      local newSelection = currentSelection == "pen" and "eraser" or "pen"
      self.tools:select(newSelection)

      Timer:tween(
        TOOLS.tween,
        {
          [self.tools[newSelection]] = {["scale"] = TOOLS.scales[1]},
          [self.tools[currentSelection]] = {["scale"] = TOOLS.scales[2]}
        }
      )
    end
  end

  if love.keyboard.waspressed("p") and self.tools.selection == "eraser" then
    if self.overlay.opacity == 0 then
      self.tools:select("pen")

      Timer:tween(
        TOOLS.tween,
        {
          [self.tools.pen] = {["scale"] = TOOLS.scales[1]},
          [self.tools.eraser] = {["scale"] = TOOLS.scales[2]}
        }
      )
    end
  end

  if love.keyboard.waspressed("e") and self.tools.selection == "pen" then
    if self.overlay.opacity == 0 then
      self.tools:select("eraser")

      Timer:tween(
        TOOLS.tween,
        {
          [self.tools.eraser] = {["scale"] = TOOLS.scales[1]},
          [self.tools.pen] = {["scale"] = TOOLS.scales[2]}
        }
      )
    end
  end

  if love.keyboard.waspressed("up") and self.highlightedCell.row > 1 then
    if self.overlay.opacity == 0 then
      self.highlightedCell.row = self.highlightedCell.row - 1
    end
  end

  if love.keyboard.waspressed("right") and self.highlightedCell.column < self.level.dimension then
    if self.overlay.opacity == 0 then
      self.highlightedCell.column = self.highlightedCell.column + 1
    end
  end

  if love.keyboard.waspressed("down") and self.highlightedCell.row < self.level.dimension then
    if self.overlay.opacity == 0 then
      self.highlightedCell.row = self.highlightedCell.row + 1
    end
  end

  if love.keyboard.waspressed("left") and self.highlightedCell.column > 1 then
    if self.overlay.opacity == 0 then
      self.highlightedCell.column = self.highlightedCell.column - 1
    end
  end
end

function PlayState:goToVictoryState()
  Timer:reset()

  gStateMachine:change(
    "victory",
    {
      ["offset"] = self.offset,
      ["level"] = self.level,
      ["data"] = self.data
    }
  )
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
    love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a)
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

    love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
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
    love.graphics.setColor(gColors.overlay.r, gColors.overlay.g, gColors.overlay.b, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
