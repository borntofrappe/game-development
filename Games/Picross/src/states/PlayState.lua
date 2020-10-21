PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.button = {
    ["tool"] = "",
    ["scale"] = {
      ["pen"] = 1,
      ["eraser"] = 1
    }
  }

  self.cell = {
    ["column"] = 1,
    ["row"] = 1
  }

  self.timer = 0

  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.transitionDuration = 0.5
  self.isTransitioning = true

  Timer.tween(
    self.transitionDuration,
    {
      [self.overlay] = {a = 0}
    }
  ):finish(
    function()
      Timer.tween(
        0.15,
        {
          [self.button.scale] = {
            ["pen"] = 1.25,
            ["eraser"] = 0.9
          }
        }
      ):finish(
        function()
          self.button.tool = "pen"
          self.interval =
            Timer.every(
            1,
            function()
              self.timer = self.timer + 1
            end
          )
        end
      )
      self.isTransitioning = false
    end
  )
end

function PlayState:enter(params)
  self.selection = params and params.selection or math.random(#LEVELS)
  self.completedLevels = params and params.completedLevels or {}
  self.level =
    Level(
    {
      ["number"] = self.selection
    }
  )

  self.size = self.level.size
  self.gridSide = self.level.gridSide
  self.cellSize = self.level.cellSize

  self.grid = {}
  for i, cell in ipairs(self.level.grid) do
    table.insert(
      self.grid,
      {
        ["column"] = cell.column,
        ["row"] = cell.row,
        ["value"] = ""
      }
    )
  end
end

function PlayState:update(dt)
  Timer.update(dt)

  local x, y = love.mouse:getPosition()
  if
    x > WINDOW_WIDTH * 5 / 7 - self.size / 2 and x < WINDOW_WIDTH * 5 / 7 + self.size / 2 and
      y > WINDOW_HEIGHT * 9 / 14 - self.size / 2 and
      y < WINDOW_HEIGHT * 9 / 14 + self.size / 2
   then
    local column = math.floor((x - (WINDOW_WIDTH * 5 / 7 - self.size / 2)) / self.cellSize) + 1
    local row = math.floor((y - (WINDOW_HEIGHT * 9 / 14 - self.size / 2)) / self.cellSize) + 1

    self.cell.column = column
    self.cell.row = row

    if love.mouse.isDown(1) then
      local column = self.cell.column
      local row = self.cell.row
      local i = column + (row - 1) * self.gridSide
      if self.button.tool == "pen" then
        self.grid[i].value = self.grid[i].value == "x" and "" or "o"
      elseif self.button.tool == "eraser" then
        self.grid[i].value = self.grid[i].value == "o" and "" or "x"
      end

      if self:checkVictory() then
        self.interval:remove()
        gStateMachine:change(
          "victory",
          {
            ["completedLevels"] = self.completedLevels,
            ["selection"] = self.selection,
            ["level"] = self.level,
            ["timer"] = self.timer
          }
        )
      end
    end
  end

  if love.mouse.wasPressed(1) then
    local x, y = love.mouse:getPosition()

    if
      x > WINDOW_WIDTH * 5 / 7 - self.size / 2 and x < WINDOW_WIDTH * 5 / 7 + self.size / 2 and
        y > WINDOW_HEIGHT * 9 / 14 - self.size / 2 and
        y < WINDOW_HEIGHT * 9 / 14 + self.size / 2
     then
      local column = self.cell.column
      local row = self.cell.row
      local i = column + (row - 1) * self.gridSide
      if self.button.tool == "pen" then
        self.grid[i].value = self.grid[i].value == "x" and "" or "o"
      elseif self.button.tool == "eraser" then
        self.grid[i].value = self.grid[i].value == "o" and "" or "x"
      end

      if self:checkVictory() then
        self.interval:remove()
        gStateMachine:change(
          "victory",
          {
            ["completedLevels"] = self.completedLevels,
            ["selection"] = self.selection,
            ["level"] = self.level,
            ["timer"] = self.timer
          }
        )
      end
    end

    if ((x - WINDOW_WIDTH / 4) ^ 2 + (y - WINDOW_HEIGHT / 2) ^ 2) ^ 0.5 < 20 then
      self.button.tool = "pen"
      Timer.tween(
        0.15,
        {
          [self.button.scale] = {
            ["pen"] = 1.25,
            ["eraser"] = 0.9
          }
        }
      )
    end

    if ((x - (WINDOW_WIDTH / 4 - 40)) ^ 2 + (y - (WINDOW_HEIGHT / 2 + 40)) ^ 2) ^ 0.5 < 20 then
      self.button.tool = "eraser"
      Timer.tween(
        0.15,
        {
          [self.button.scale] = {
            ["pen"] = 0.9,
            ["eraser"] = 1.25
          }
        }
      )
    end
  end

  if love.keyboard.wasPressed("escape") and not self.isTransitioning then
    self.isTransitioning = true

    self.button.tool = ""
    Timer.tween(
      0.15,
      {
        [self.button.scale] = {
          ["pen"] = 1,
          ["eraser"] = 1
        }
      }
    ):finish(
      function()
        Timer.tween(
          self.transitionDuration,
          {
            [self.overlay] = {a = 1}
          }
        ):finish(
          function()
            self.interval:remove()
            gStateMachine:change(
              "select",
              {
                ["selection"] = self.selection,
                ["completedLevels"] = self.completedLevels
              }
            )
          end
        )
      end
    )
  end

  if love.keyboard.wasPressed("p") or love.keyboard.wasPressed("P") then
    if self.button.tool ~= "pen" then
      self.button.tool = "pen"
      Timer.tween(
        0.15,
        {
          [self.button.scale] = {
            ["pen"] = 1.25,
            ["eraser"] = 0.9
          }
        }
      )
    end
  elseif love.keyboard.wasPressed("e") or love.keyboard.wasPressed("E") then
    if self.button.tool ~= "eraser" then
      self.button.tool = "eraser"
      Timer.tween(
        0.15,
        {
          [self.button.scale] = {
            ["pen"] = 0.9,
            ["eraser"] = 1.25
          }
        }
      )
    end
  end

  if love.keyboard.wasPressed("tab") then
    self.button.tool = self.button.tool == "eraser" and "pen" or "eraser"
    Timer.tween(
      0.15,
      {
        [self.button.scale] = {
          ["pen"] = self.button.tool == "pen" and 1.25 or 0.9,
          ["eraser"] = self.button.tool == "eraser" and 1.25 or 0.9
        }
      }
    )
  end

  if love.keyboard.wasPressed("up") then
    self.cell.row = math.max(1, self.cell.row - 1)
  elseif love.keyboard.wasPressed("down") then
    self.cell.row = math.min(self.gridSide, self.cell.row + 1)
  elseif love.keyboard.wasPressed("right") then
    self.cell.column = math.min(self.gridSide, self.cell.column + 1)
  elseif love.keyboard.wasPressed("left") then
    self.cell.column = math.max(1, self.cell.column - 1)
  end

  if love.mouse.wasPressed(1) then
  --
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    local column = self.cell.column
    local row = self.cell.row
    local i = column + (row - 1) * self.gridSide
    if self.button.tool == "pen" then
      self.grid[i].value = self.grid[i].value == "x" and "" or "o"
    elseif self.button.tool == "eraser" then
      self.grid[i].value = self.grid[i].value == "o" and "" or "x"
    end

    if self:checkVictory() then
      self.interval:remove()
      gStateMachine:change(
        "victory",
        {
          ["completedLevels"] = self.completedLevels,
          ["selection"] = self.selection,
          ["level"] = self.level,
          ["timer"] = self.timer
        }
      )
    end
  end
end

function PlayState:render()
  love.graphics.translate(WINDOW_WIDTH * 5 / 7, WINDOW_HEIGHT * 9 / 14)
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)

  self.level:render()

  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)

  for i, cell in ipairs(self.grid) do
    if cell.value == "o" then
      love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
      love.graphics.rectangle(
        "fill",
        -self.size / 2 + (cell.column - 1) * self.cellSize,
        -self.size / 2 + (cell.row - 1) * self.cellSize,
        self.cellSize,
        self.cellSize
      )
    elseif cell.value == "x" then
      love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
      love.graphics.line(
        -self.size / 2 + (cell.column - 1) * self.cellSize + self.cellSize / 4,
        -self.size / 2 + (cell.row - 1) * self.cellSize + self.cellSize / 4,
        -self.size / 2 + (cell.column - 1) * self.cellSize + self.cellSize * 3 / 4,
        -self.size / 2 + (cell.row - 1) * self.cellSize + self.cellSize * 3 / 4
      )
      love.graphics.line(
        -self.size / 2 + (cell.column - 1) * self.cellSize + self.cellSize * 3 / 4,
        -self.size / 2 + (cell.row - 1) * self.cellSize + self.cellSize / 4,
        -self.size / 2 + (cell.column - 1) * self.cellSize + self.cellSize / 4,
        -self.size / 2 + (cell.row - 1) * self.cellSize + self.cellSize * 3 / 4
      )
    end
  end

  love.graphics.setLineWidth(1)
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  for i = 1, self.gridSide + 1 do
    love.graphics.line(
      -self.size / 2 + (i - 1) * self.cellSize,
      -self.size / 2,
      -self.size / 2 + (i - 1) * self.cellSize,
      self.size / 2
    )
    love.graphics.line(
      -self.size / 2,
      -self.size / 2 + (i - 1) * self.cellSize,
      self.size / 2,
      -self.size / 2 + (i - 1) * self.cellSize
    )
  end

  love.graphics.setLineWidth(2)
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.rectangle(
    "fill",
    -self.size / 2 + (self.cell.column - 1) * self.cellSize,
    -self.size / 2 - 8 - #self.level.hints.columns[self.cell.column] * gSizes["height-font-normal"] * 1.5 -
      gSizes["height-font-normal"] / 2,
    self.cellSize,
    8 + #self.level.hints.columns[self.cell.column] * gSizes["height-font-normal"] * 1.5 +
      gSizes["height-font-normal"] / 2
  )
  love.graphics.rectangle(
    "fill",
    -self.size / 2 - 8 - #self.level.hints.rows[self.cell.row] * gSizes["height-font-normal"] * 1.5 -
      gSizes["height-font-normal"] / 2,
    -self.size / 2 + (self.cell.row - 1) * self.cellSize,
    8 + #self.level.hints.rows[self.cell.row] * gSizes["height-font-normal"] * 1.5 + gSizes["height-font-normal"] / 2,
    self.cellSize
  )

  love.graphics.rectangle(
    "fill",
    -self.size / 2 + (self.cell.column - 1) * self.cellSize,
    -self.size / 2 + (self.cell.row - 1) * self.cellSize,
    self.cellSize,
    self.cellSize
  )
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle(
    "line",
    -self.size / 2 + (self.cell.column - 1) * self.cellSize,
    -self.size / 2 + (self.cell.row - 1) * self.cellSize,
    self.cellSize,
    self.cellSize
  )

  love.graphics.translate(-WINDOW_WIDTH * 5 / 7, -WINDOW_HEIGHT * 9 / 14)

  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.print(
    "Level " .. self.selection,
    WINDOW_WIDTH / 4 - 90,
    WINDOW_HEIGHT / 4 - 7 - 8 - gSizes["height-font-small"]
  )

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 4 - 86, WINDOW_HEIGHT / 4 - 3, 140, 12 + gSizes["height-font-normal"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle("fill", WINDOW_WIDTH / 4 - 90, WINDOW_HEIGHT / 4 - 7, 140, 12 + gSizes["height-font-normal"])
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.printf(formatTimer(self.timer), WINDOW_WIDTH / 4 - 84, WINDOW_HEIGHT / 4, 128, "right")

  love.graphics.translate(WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2)
  love.graphics.scale(self.button.scale.pen, self.button.scale.pen)
  if self.button.tool == "pen" then
    love.graphics.setColor(
      gColors["highlight"].r,
      gColors["highlight"].g,
      gColors["highlight"].b,
      gColors["highlight"].a
    )
    love.graphics.circle("fill", 0, 0, 20)
  end
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.circle("fill", 0, 0, 20)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, 20)
  love.graphics.polygon("fill", 4, -9.5, -8, 2.5, -8, 7.5, -3, 7.5, 9, -4.5)
  love.graphics.scale(2 - self.button.scale.pen, 2 - self.button.scale.pen)

  love.graphics.translate(-40, 40)
  love.graphics.scale(self.button.scale.eraser, self.button.scale.eraser)
  if self.button.tool == "eraser" then
    love.graphics.setColor(
      gColors["highlight"].r,
      gColors["highlight"].g,
      gColors["highlight"].b,
      gColors["highlight"].a
    )
    love.graphics.circle("fill", 0, 0, 20)
  end
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.circle("fill", 0, 0, 20)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, 20)
  love.graphics.setLineWidth(3)
  love.graphics.line(-5.5, -5.5, 5.5, 5.5)
  love.graphics.line(-5.5, 5.5, 5.5, -5.5)
  love.graphics.scale(2 - self.button.scale.eraser, 2 - self.button.scale.eraser)

  love.graphics.translate(-WINDOW_WIDTH / 4 + 40, -WINDOW_HEIGHT / 2 - 40)
  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function PlayState:checkVictory()
  for i = 1, #self.grid do
    if self.level.grid[i].value == "o" and self.grid[i].value ~= self.level.grid[i].value then
      return false
    end
    if self.grid[i].value == "o" and self.level.grid[i].value ~= "o" then
      return false
    end
  end

  return true
end
