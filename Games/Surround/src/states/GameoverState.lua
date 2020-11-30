GameoverState = BaseState:create()

function GameoverState:enter(params)
  self.winner = params.winner

  local color =
    self.winner and self.winner.color or
    {
      ["r"] = COLORS.text.r,
      ["g"] = COLORS.text.g,
      ["b"] = COLORS.text.b
    }

  grid = {}
  for column = 1, math.floor(WINDOW_WIDTH / CELL_SIZE) + 1 do
    grid[column] = {}
    for row = 1, math.floor(WINDOW_HEIGHT / CELL_SIZE) + 1 do
      grid[column][row] = {
        ["column"] = column,
        ["row"] = row,
        ["size"] = CELL_SIZE,
        ["color"] = (column + row) % 2 == 0 and
          {
            ["r"] = color.r,
            ["g"] = color.g,
            ["b"] = color.b,
            ["a"] = OPACITY
          } or
          {
            ["r"] = color.r,
            ["g"] = color.g,
            ["b"] = color.b,
            ["a"] = OPACITY / 2
          }
      }
    end
  end
  self.grid = grid

  self.canvas = self:getCanvas()
end

function GameoverState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("return") then
    gSounds["select"]:stop()
    gSounds["select"]:play()
    gStateMachine:change("play")
  end
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.canvas)

  love.graphics.setBlendMode("alpha")

  if self.winner then
    love.graphics.setColor(self.winner.color.r, self.winner.color.g, self.winner.color.b)
    love.graphics.setFont(gFonts["big"])
    love.graphics.printf("Gameover", 4, WINDOW_HEIGHT / 2 - gFonts["big"]:getHeight() + 4, WINDOW_WIDTH, "center")
    love.graphics.setFont(gFonts["normal"])
    love.graphics.printf(string.upper("Congrats"), 2, WINDOW_HEIGHT / 2 + 26, WINDOW_WIDTH, "center")
    love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
    love.graphics.printf(string.upper("Congrats"), 0, WINDOW_HEIGHT / 2 + 24, WINDOW_WIDTH, "center")
  end

  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Gameover", 0, WINDOW_HEIGHT / 2 - gFonts["big"]:getHeight(), WINDOW_WIDTH, "center")
end

function GameoverState:getCanvas()
  local grid = self.grid

  local canvas = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  for c = 1, #grid do
    for r = 1, #grid[c] do
      local cell = grid[c][r]
      love.graphics.setColor(cell.color.r, cell.color.g, cell.color.b, cell.color.a)
      love.graphics.rectangle("fill", (cell.column - 1) * cell.size, (cell.row - 1) * cell.size, cell.size, cell.size)
    end
  end

  love.graphics.setCanvas()

  return canvas
end
