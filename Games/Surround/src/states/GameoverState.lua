GameoverState = BaseState:create()

function GameoverState:enter(params)
  self.winner = params.winner

  local color =
    self.winner and self.winner.color or
    {
      ["r"] = 0.3,
      ["g"] = 0.3,
      ["b"] = 0.3
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
            ["a"] = 0.5
          } or
          {
            ["r"] = color.r,
            ["g"] = color.g,
            ["b"] = color.b,
            ["a"] = 0.3
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
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.printf(string.upper("Congrats"), 0, WINDOW_HEIGHT / 2 + 24, WINDOW_WIDTH, "center")
  end

  love.graphics.setColor(0.3, 0.3, 0.3)
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
      love.graphics.setColor(grid[c][r].color.r, grid[c][r].color.g, grid[c][r].color.b, grid[c][r].color.a)
      love.graphics.rectangle(
        "fill",
        (grid[c][r].column - 1) * grid[c][r].size,
        (grid[c][r].row - 1) * grid[c][r].size,
        grid[c][r].size,
        grid[c][r].size
      )
    end
  end

  love.graphics.setCanvas()

  return canvas
end
