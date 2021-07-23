PlayState = BaseState:new()

local TIMER_INTERVAL = 1
local EXTRA_TWEEN = 0.5

local TOOLS = {
  ["tween"] = 0.2,
  ["scales"] = {1, 0.7}
}

function PlayState:enter(params)
  self.active = false

  self.overlay = {
    ["opacity"] = 1
  }

  self.extra = {
    ["opacity"] = 1
  }

  self.x = WINDOW_WIDTH - GRID_SIZE - GRID_PADDING.x
  self.y = WINDOW_HEIGHT - GRID_SIZE - GRID_PADDING.y
  self.size = GRID_SIZE

  self.index = params.index
  self.level = Level:new(self.index, self.x, self.y, self.size)

  self.dimension = self.level.dimension
  self.cellSize = self.level.cellSize

  local hints = {
    ["columns"] = {},
    ["rows"] = {}
  }

  for row = 1, self.dimension do
    for column = 1, self.dimension do
      local index = column + (row - 1) * self.dimension
      local state = self.level.grid[index].state

      if not hints.columns[column] then
        hints.columns[column] = {0}
      end

      if not hints.rows[row] then
        hints.rows[row] = {0}
      end

      if state == "o" then
        hints.columns[column][#hints.columns[column]] = hints.columns[column][#hints.columns[column]] + 1
        hints.rows[row][#hints.rows[row]] = hints.rows[row][#hints.rows[row]] + 1
      else
        if hints.columns[column][#hints.columns[column]] ~= 0 then
          hints.columns[column][#hints.columns[column] + 1] = 0
        end
        if hints.rows[row][#hints.rows[row]] ~= 0 then
          hints.rows[row][#hints.rows[row] + 1] = 0
        end
      end
    end
  end

  for i, hintColumn in ipairs(hints.columns) do
    if #hintColumn > 1 and hintColumn[#hintColumn] == 0 then
      table.remove(hintColumn)
    end
  end

  for i, hintRow in ipairs(hints.rows) do
    if #hintRow > 1 and hintRow[#hintRow] == 0 then
      table.remove(hintRow)
    end
  end

  self.hints = hints

  self.highlightedCell = {
    ["column"] = math.random(self.dimension),
    ["row"] = math.random(self.dimension)
  }

  self.data = Data:new(self.level)
  self.tools = Tools:new()

  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    },
    function()
      self.tools:select("pen")
      Timer:tween(
        TOOLS.tween,
        {
          [self.tools.pen] = {["scale"] = TOOLS.scales[1]},
          [self.tools.eraser] = {["scale"] = TOOLS.scales[2]}
        },
        function()
          self.active = true
        end
      )

      Timer:every(
        TIMER_INTERVAL,
        function()
          self.data.timer.time = self.data.timer.time + 1
        end
      )
    end
  )
end

function PlayState:goToSelectState()
  gSounds["confirm"]:play()

  self.active = false

  Timer:reset()
  Timer:tween(
    TOOLS.tween,
    {
      [self.tools.pen] = {["scale"] = 0},
      [self.tools.eraser] = {["scale"] = 0}
    },
    function()
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
  )
end

function PlayState:goToVictoryState()
  gSounds["victory"]:play()

  self.active = false

  for k, cell in pairs(self.level.grid) do
    if cell.value == "x" then
      cell.value = nil
    end
  end

  Timer:reset()
  Timer:tween(
    EXTRA_TWEEN,
    {
      [self.extra] = {["opacity"] = 0},
      [self.tools.pen] = {["scale"] = 0},
      [self.tools.eraser] = {["scale"] = 0}
    },
    function()
      gStateMachine:change(
        "victory",
        {
          ["level"] = self.level,
          ["data"] = self.data
        }
      )
    end
  )
end

function PlayState:selectCell()
  local column = self.highlightedCell.column
  local row = self.highlightedCell.row
  local index = column + (row - 1) * self.dimension

  if self.tools.selection == "pen" then
    if self.level.grid[index].value == "x" then
      self.level.grid[index].value = nil
    else
      gSounds["pen"]:stop()
      gSounds["pen"]:play()

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
      gSounds["eraser"]:stop()
      gSounds["eraser"]:play()

      self.level.grid[index].value = "x"
    end
  end
end

function PlayState:selectPen()
  gSounds["confirm"]:stop()
  gSounds["confirm"]:play()

  self.tools:select("pen")

  Timer:tween(
    TOOLS.tween,
    {
      [self.tools.pen] = {["scale"] = TOOLS.scales[1]},
      [self.tools.eraser] = {["scale"] = TOOLS.scales[2]}
    }
  )
end

function PlayState:selectEraser()
  gSounds["confirm"]:stop()
  gSounds["confirm"]:play()

  self.tools:select("eraser")

  Timer:tween(
    TOOLS.tween,
    {
      [self.tools.eraser] = {["scale"] = TOOLS.scales[1]},
      [self.tools.pen] = {["scale"] = TOOLS.scales[2]}
    }
  )
end

function PlayState:update(dt)
  Timer:update(dt)

  if gMouseInput then
    local x, y = love.mouse:getPosition()
    if x > self.level.x and x < self.level.x + self.size and y > self.level.y and y < self.level.y + self.size then
      local column = math.floor((x - self.level.x) / self.cellSize) + 1
      local row = math.floor((y - self.level.y) / self.cellSize) + 1

      if column ~= self.highlightedCell.column or row ~= self.highlightedCell.row then
        self.highlightedCell.column = column
        self.highlightedCell.row = row

        if love.mouse.isDown(1) then
          self:selectCell()
        else
          gSounds["select"]:stop()
          gSounds["select"]:play()
        end
      end
    end
  end

  if love.mouse.waspressed(1) then
    if self.active then
      local x, y = love.mouse:getPosition()
      if x ^ 2 + y ^ 2 < BACK_BUTTON_RADIUS ^ 2 then
        self:goToSelectState()
      else
        if x > self.level.x and x < self.level.x + self.size and y > self.level.y and y < self.level.y + self.size then
          self:selectCell()
        else
          if (x - self.tools.pen.x) ^ 2 + (y - self.tools.pen.y) ^ 2 < (self.tools.pen.r * self.tools.pen.scale) ^ 2 then
            self:selectPen()
          elseif
            (x - self.tools.eraser.x) ^ 2 + (y - self.tools.eraser.y) ^ 2 <
              (self.tools.eraser.r * self.tools.eraser.scale) ^ 2
           then
            self:selectEraser()
          end
        end
      end
    end
  end

  if love.keyboard.waspressed("escape") then
    if self.active then
      self:goToSelectState()
    end
  end

  if love.keyboard.waspressed("return") then
    if self.active then
      self:selectCell()
    end
  end

  if love.keyboard.waspressed("space") or love.keyboard.waspressed("tab") or love.keyboard.waspressed("x") then
    if self.active then
      if self.tools.selection == "pen" then
        self:selectEraser()
      else
        self:selectPen()
      end
    end
  end

  if love.keyboard.waspressed("p") and self.tools.selection == "eraser" then
    if self.active then
      self:selectPen()
    end
  end

  if love.keyboard.waspressed("e") and self.tools.selection == "pen" then
    if self.active then
      self:selectEraser()
    end
  end

  if
    love.keyboard.waspressed("up") or love.keyboard.waspressed("right") or love.keyboard.waspressed("down") or
      love.keyboard.waspressed("left")
   then
    if self.active then
      gSounds["select"]:stop()
      gSounds["select"]:play()

      if love.keyboard.waspressed("up") and self.highlightedCell.row > 1 then
        self.highlightedCell.row = self.highlightedCell.row - 1
      end

      if love.keyboard.waspressed("right") and self.highlightedCell.column < self.dimension then
        self.highlightedCell.column = self.highlightedCell.column + 1
      end

      if love.keyboard.waspressed("down") and self.highlightedCell.row < self.dimension then
        self.highlightedCell.row = self.highlightedCell.row + 1
      end

      if love.keyboard.waspressed("left") and self.highlightedCell.column > 1 then
        self.highlightedCell.column = self.highlightedCell.column - 1
      end

      if love.keyboard.isDown("return") then
        self:selectCell()
      end
    end
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

  love.graphics.setColor(gColors.highlight.r, gColors.highlight.g, gColors.highlight.b, self.extra.opacity)
  love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)

  love.graphics.setLineWidth(1)
  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, gColors.shadow.a * self.extra.opacity)
  for k = 1, self.dimension + 1 do
    love.graphics.line(self.x + (k - 1) * self.cellSize, self.y, self.x + (k - 1) * self.cellSize, self.y + self.size)
    love.graphics.line(self.x, self.y + (k - 1) * self.cellSize, self.x + self.size, self.y + (k - 1) * self.cellSize)
  end

  self.level:render()

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b, self.extra.opacity)
  love.graphics.setFont(gFonts.normal)
  for i, hintsColumn in ipairs(self.hints.columns) do
    for j, hintColumn in ipairs(hintsColumn) do
      love.graphics.printf(
        hintColumn,
        self.x + self.cellSize * (i - 1),
        self.y + self.cellSize * (#hintsColumn - j + 1) * -1 + self.cellSize / 2 - gFonts.normal:getHeight() / 2,
        self.cellSize,
        "center"
      )
    end
  end

  for i, hintsRow in ipairs(self.hints.rows) do
    for j, hintRow in ipairs(hintsRow) do
      love.graphics.printf(
        hintRow,
        self.x + self.cellSize * (#hintsRow - j + 1) * -1,
        self.y + self.cellSize * (i - 1) + self.cellSize / 2 - gFonts.normal:getHeight() / 2,
        self.cellSize,
        "center"
      )
    end
  end

  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, self.extra.opacity * gColors.shadow.a)
  love.graphics.rectangle(
    "fill",
    self.x + self.cellSize * #self.hints.rows[self.highlightedCell.row] * -1,
    self.y + (self.highlightedCell.row - 1) * self.cellSize,
    self.cellSize * #self.hints.rows[self.highlightedCell.row],
    self.cellSize
  )

  love.graphics.rectangle(
    "fill",
    self.x + (self.highlightedCell.column - 1) * self.cellSize,
    self.y + self.cellSize * #self.hints.columns[self.highlightedCell.column] * -1,
    self.cellSize,
    self.cellSize * #self.hints.columns[self.highlightedCell.column]
  )

  love.graphics.rectangle(
    "fill",
    self.x + (self.highlightedCell.column - 1) * self.cellSize,
    self.y + (self.highlightedCell.row - 1) * self.cellSize,
    self.cellSize,
    self.cellSize
  )

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b, self.extra.opacity)
  love.graphics.setLineWidth(3)
  love.graphics.rectangle(
    "line",
    self.x + (self.highlightedCell.column - 1) * self.cellSize,
    self.y + (self.highlightedCell.row - 1) * self.cellSize,
    self.cellSize,
    self.cellSize
  )

  if gMouseInput then
    drawBackButton()
  end

  if not self.active then
    love.graphics.setColor(gColors.overlay.r, gColors.overlay.g, gColors.overlay.b, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
