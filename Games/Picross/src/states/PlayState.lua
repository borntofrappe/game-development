PlayState = Class({__includes = BaseState})

function PlayState:init()
  -- initial scale for the two circles
  -- 1 to avoid scaling the overlay used for the transition
  self.button = {
    ["tool"] = "",
    ["scale"] = {
      ["pen"] = 1,
      ["eraser"] = 1
    },
    ["position"] = {
      ["pen"] = {
        ["x"] = WINDOW_WIDTH / 4,
        ["y"] = WINDOW_HEIGHT / 2
      },
      ["eraser"] = {
        ["x"] = WINDOW_WIDTH / 4 - 40,
        ["y"] = WINDOW_HEIGHT / 2 + 40
      }
    },
    ["r"] = 20
  }

  -- counter variable to keep track of time
  self.timer = {
    ["x"] = WINDOW_WIDTH / 4 - 84,
    ["y"] = WINDOW_HEIGHT / 4,
    ["width"] = 128,
    ["height"] = gSizes["height-font-normal"],
    ["value"] = 0
  }

  -- table describing the cell being selected
  self.cell = {
    ["column"] = 1,
    ["row"] = 1
  }

  -- fade in
  self.overlay = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 1
  }
  self.transitionDuration = TRANSITION_DURATION / 2
  self.isTransitioning = true

  Timer.tween(
    self.transitionDuration,
    {
      [self.overlay] = {a = 0}
    }
  ):finish(
    function()
      -- scale the circles to describe how the game starts with the pen tool
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
          -- update counter variable
          self.interval =
            Timer.every(
            1,
            function()
              self.timer.value = self.timer.value + 1
            end
          )
          self.isTransitioning = false
        end
      )
    end
  )
end

function PlayState:enter(params)
  -- level being selected
  self.selection = params and params.selection or math.random(#LEVELS)
  self.level =
    Level(
    {
      ["number"] = self.selection
    }
  )
  self.completedLevels = params and params.completedLevels or {}

  self.message = {
    ["text"] = "Level " .. self.selection,
    ["x"] = WINDOW_WIDTH / 4 - 90,
    ["y"] = WINDOW_HEIGHT / 4 - 7 - 8 - gSizes["height-font-small"]
  }

  -- build a grid to describe the player's input
  -- matching the grid of the level in size, dimension and length
  self.grid = {
    ["cells"] = {},
    ["size"] = self.level.gridSize,
    ["dimension"] = self.level.gridDimension,
    ["cellSize"] = self.level.cellSize
  }

  self.grid.x = WINDOW_WIDTH * 5 / 7 - self.grid.size / 2
  self.grid.y = WINDOW_HEIGHT * 9 / 14 - self.grid.size / 2

  -- populate the grid's cells table using the cells of the level
  for i, cell in ipairs(self.level.grid) do
    table.insert(
      self.grid.cells,
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

  -- keyboard input
  if love.keyboard.wasPressed("escape") and not self.isTransitioning then
    -- move to the select state only after the scale of the buttons is reset
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
        self:goToSelectState()
      end
    )
  end

  if (love.keyboard.wasPressed("p") or love.keyboard.wasPressed("P")) and self.button.tool ~= "pen" then
    self:updateButton("pen")
  elseif (love.keyboard.wasPressed("e") or love.keyboard.wasPressed("E")) and self.button.tool ~= "eraser" then
    self:updateButton("eraser")
  end

  if love.keyboard.wasPressed("tab") or love.keyboard.wasPressed("x") or love.keyboard.wasPressed("X") then
    local tool = self.button.tool == "eraser" and "pen" or "eraser"
    self:updateButton(tool)
  end

  if love.keyboard.wasPressed("up") then
    self.cell.row = math.max(1, self.cell.row - 1)
  elseif love.keyboard.wasPressed("down") then
    self.cell.row = math.min(self.grid.dimension, self.cell.row + 1)
  elseif love.keyboard.wasPressed("right") then
    self.cell.column = math.min(self.grid.dimension, self.cell.column + 1)
  elseif love.keyboard.wasPressed("left") then
    self.cell.column = math.max(1, self.cell.column - 1)
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    self:updateGrid()
  end

  -- mouse input
  -- update the selected cell when hovering on the grid
  local x, y = love.mouse:getPosition()
  if x > self.grid.x and x < self.grid.x + self.grid.size and y > self.grid.y and y < self.grid.y + self.grid.size then
    local column = math.floor((x - (self.grid.x)) / self.grid.cellSize) + 1
    local row = math.floor((y - (self.grid.y)) / self.grid.cellSize) + 1

    self.cell.column = column
    self.cell.row = row
  end

  -- on mouseclick consider input in the grid vs. input in the buttons
  if love.mouse.wasPressed(1) then
    local x, y = love.mouse:getPosition()
    -- in the grid update the cell with the current tool
    if x > self.grid.x and x < self.grid.x + self.grid.size and y > self.grid.y and y < self.grid.y + self.grid.size then
      self:updateGrid()
    end

    -- in the buttons update the current tool
    if ((x - self.button.position.pen.x) ^ 2 + (y - self.button.position.pen.y) ^ 2) ^ 0.5 < self.button.r then
      self:updateButton("pen")
    end

    if ((x - self.button.position.eraser.x) ^ 2 + (y - self.button.position.eraser.y) ^ 2) ^ 0.5 < self.button.r then
      self:updateButton("eraser")
    end
  end
end

function PlayState:render()
  -- backdrop
  love.graphics.translate(self.grid.x + self.grid.size / 2, self.grid.y + self.grid.size / 2)
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.rectangle("fill", -self.grid.size / 2, -self.grid.size / 2, self.grid.size, self.grid.size)

  -- actual level
  self.level:render()

  -- overlay
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.rectangle("fill", -self.grid.size / 2, -self.grid.size / 2, self.grid.size, self.grid.size)

  -- player choices
  for i, cell in ipairs(self.grid.cells) do
    if cell.value == "o" then
      love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
      love.graphics.rectangle(
        "fill",
        -self.grid.size / 2 + (cell.column - 1) * self.grid.cellSize,
        -self.grid.size / 2 + (cell.row - 1) * self.grid.cellSize,
        self.grid.cellSize,
        self.grid.cellSize
      )
    elseif cell.value == "x" then
      love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
      love.graphics.line(
        -self.grid.size / 2 + (cell.column - 1) * self.grid.cellSize + self.grid.cellSize / 4,
        -self.grid.size / 2 + (cell.row - 1) * self.grid.cellSize + self.grid.cellSize / 4,
        -self.grid.size / 2 + (cell.column - 1) * self.grid.cellSize + self.grid.cellSize * 3 / 4,
        -self.grid.size / 2 + (cell.row - 1) * self.grid.cellSize + self.grid.cellSize * 3 / 4
      )
      love.graphics.line(
        -self.grid.size / 2 + (cell.column - 1) * self.grid.cellSize + self.grid.cellSize * 3 / 4,
        -self.grid.size / 2 + (cell.row - 1) * self.grid.cellSize + self.grid.cellSize / 4,
        -self.grid.size / 2 + (cell.column - 1) * self.grid.cellSize + self.grid.cellSize / 4,
        -self.grid.size / 2 + (cell.row - 1) * self.grid.cellSize + self.grid.cellSize * 3 / 4
      )
    end
  end

  -- grid lines
  love.graphics.setLineWidth(1)
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  for i = 1, self.grid.dimension + 1 do
    love.graphics.line(
      -self.grid.size / 2 + (i - 1) * self.grid.cellSize,
      -self.grid.size / 2,
      -self.grid.size / 2 + (i - 1) * self.grid.cellSize,
      self.grid.size / 2
    )
    love.graphics.line(
      -self.grid.size / 2,
      -self.grid.size / 2 + (i - 1) * self.grid.cellSize,
      self.grid.size / 2,
      -self.grid.size / 2 + (i - 1) * self.grid.cellSize
    )
  end

  -- selected cell
  -- highlight accompanying hints (row and column)
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.rectangle(
    "fill",
    -self.grid.size / 2 + (self.cell.column - 1) * self.grid.cellSize,
    -self.grid.size / 2 - 8 - #self.level.hints.columns[self.cell.column] * gSizes["height-font-normal"] * 1.5 -
      gSizes["height-font-normal"] / 2,
    self.grid.cellSize,
    8 + #self.level.hints.columns[self.cell.column] * gSizes["height-font-normal"] * 1.5 +
      gSizes["height-font-normal"] / 2
  )
  love.graphics.rectangle(
    "fill",
    -self.grid.size / 2 - 8 - #self.level.hints.rows[self.cell.row] * gSizes["height-font-normal"] * 1.5 -
      gSizes["height-font-normal"] / 2,
    -self.grid.size / 2 + (self.cell.row - 1) * self.grid.cellSize,
    8 + #self.level.hints.rows[self.cell.row] * gSizes["height-font-normal"] * 1.5 + gSizes["height-font-normal"] / 2,
    self.grid.cellSize
  )

  -- highlight cell
  love.graphics.rectangle(
    "fill",
    -self.grid.size / 2 + (self.cell.column - 1) * self.grid.cellSize,
    -self.grid.size / 2 + (self.cell.row - 1) * self.grid.cellSize,
    self.grid.cellSize,
    self.grid.cellSize
  )

  love.graphics.setLineWidth(2)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle(
    "line",
    -self.grid.size / 2 + (self.cell.column - 1) * self.grid.cellSize,
    -self.grid.size / 2 + (self.cell.row - 1) * self.grid.cellSize,
    self.grid.cellSize,
    self.grid.cellSize
  )

  love.graphics.translate(-self.grid.x - self.grid.size / 2, -self.grid.y - self.grid.size / 2)

  -- level and timer
  love.graphics.setFont(gFonts["small"])
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.print("Level " .. self.selection, self.timer.x - 6, self.timer.y - 8 - gSizes["height-font-small"])

  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.rectangle("fill", self.timer.x - 2, self.timer.y - 3, self.timer.width + 12, self.timer.height + 12)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.rectangle("fill", self.timer.x - 6, self.timer.y - 7, self.timer.width + 12, self.timer.height + 12)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(gColors["highlight"].r, gColors["highlight"].g, gColors["highlight"].b, gColors["highlight"].a)
  love.graphics.printf(formatTimer(self.timer.value), self.timer.x, self.timer.y, self.timer.width, "right")

  -- buttons tools
  love.graphics.translate(self.button.position.pen.x, self.button.position.pen.y)
  love.graphics.scale(self.button.scale.pen, self.button.scale.pen)
  if self.button.tool == "pen" then
    love.graphics.setColor(
      gColors["highlight"].r,
      gColors["highlight"].g,
      gColors["highlight"].b,
      gColors["highlight"].a
    )
    love.graphics.circle("fill", 0, 0, self.button.r)
  end
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.circle("fill", 0, 0, self.button.r)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, self.button.r)
  love.graphics.polygon("fill", 4, -9.5, -8, 2.5, -8, 7.5, -3, 7.5, 9, -4.5)
  love.graphics.scale(2 - self.button.scale.pen, 2 - self.button.scale.pen)

  love.graphics.translate(
    -self.button.position.pen.x + self.button.position.eraser.x,
    -self.button.position.pen.y + self.button.position.eraser.y
  )
  love.graphics.scale(self.button.scale.eraser, self.button.scale.eraser)
  if self.button.tool == "eraser" then
    love.graphics.setColor(
      gColors["highlight"].r,
      gColors["highlight"].g,
      gColors["highlight"].b,
      gColors["highlight"].a
    )
    love.graphics.circle("fill", 0, 0, self.button.r)
  end
  love.graphics.setColor(gColors["shadow"].r, gColors["shadow"].g, gColors["shadow"].b, gColors["shadow"].a)
  love.graphics.circle("fill", 0, 0, self.button.r)
  love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, gColors["text"].a)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, self.button.r)
  love.graphics.setLineWidth(3)
  love.graphics.line(-5.5, -5.5, 5.5, 5.5)
  love.graphics.line(-5.5, 5.5, 5.5, -5.5)
  love.graphics.scale(2 - self.button.scale.eraser, 2 - self.button.scale.eraser)

  love.graphics.translate(-self.button.position.eraser.x, -self.button.position.eraser.y)

  -- overlay
  love.graphics.setColor(self.overlay.r, self.overlay.g, self.overlay.b, self.overlay.a)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function PlayState:checkVictory()
  for i = 1, #self.grid.cells do
    if self.level.grid[i].value == "o" and self.grid.cells[i].value ~= self.level.grid[i].value then
      return false
    end
    if self.grid.cells[i].value == "o" and self.level.grid[i].value ~= "o" then
      return false
    end
  end

  return true
end

function PlayState:updateButton(tool)
  self.button.tool = tool
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

function PlayState:updateGrid()
  local column = self.cell.column
  local row = self.cell.row

  local i = column + (row - 1) * self.grid.dimension

  if self.button.tool == "pen" then
    self.grid.cells[i].value = self.grid.cells[i].value == "x" and "" or "o"
  elseif self.button.tool == "eraser" then
    self.grid.cells[i].value = self.grid.cells[i].value == "o" and "" or "x"
  end

  if self:checkVictory() then
    self:goToVictoryState()
  end
end

function PlayState:goToSelectState()
  self.isTransitioning = true

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
          ["selection"] = self.button.selection,
          ["completedLevels"] = self.completedLevels
        }
      )
    end
  )
end

function PlayState:goToVictoryState()
  self.interval:remove()
  gStateMachine:change(
    "victory",
    {
      ["selection"] = self.selection,
      ["level"] = self.level,
      ["completedLevels"] = self.completedLevels,
      ["timer"] = self.timer,
      ["grid"] = self.grid
    }
  )
end
