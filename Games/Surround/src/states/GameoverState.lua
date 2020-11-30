GameoverState = BaseState:create()

function GameoverState:enter(params)
  local winner = params.winner

  local color =
    winner and winner.color or
    {
      ["r"] = 0.3,
      ["g"] = 0.3,
      ["b"] = 0.3
    }

  grid = {}
  for column = 1, math.floor(WINDOW_WIDTH / CELL_SIZE) + 1 do
    grid[column] = {}
    for row = 1, math.floor(WINDOW_HEIGHT / CELL_SIZE) + 1 do
      -- if winner and (winner.column + winner.row) % 2 == 0 then
      --   everyOther = not everyOther
      -- end

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
    gStateMachine:change("play")
  end
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.canvas)
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
