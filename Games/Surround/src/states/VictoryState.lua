VictoryState = BaseState:create()

function VictoryState:enter(params)
  self.p = params.winner
  self.p.trail = {}

  self.world = params.world
  self.offsetCanvas = params.offsetCanvas

  grid = {}
  for column = 1, self.world.columns do
    grid[column] = {}
    for row = 1, self.world.rows do
      local everyOther = (column + row) % 2 == 1
      if (self.p.column + self.p.row) % 2 == 0 then
        everyOther = not everyOther
      end
      local color =
        everyOther and
        {
          ["r"] = self.p.color.r,
          ["g"] = self.p.color.g,
          ["b"] = self.p.color.b,
          ["a"] = 0.5
        } or
        {
          ["r"] = self.p.color.r,
          ["g"] = self.p.color.g,
          ["b"] = self.p.color.b,
          ["a"] = 0.3
        }

      grid[column][row] = {
        ["column"] = column,
        ["row"] = row,
        ["size"] = self.p.size,
        ["color"] = color
      }
    end
  end
  self.grid = grid

  self.canvas = self:getCanvas()
end

function VictoryState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("return") then
    Timer:reset()
    gStateMachine:change("play")
  end
end

function VictoryState:render()
  if self.offsetCanvas then
    love.graphics.translate(CANVAS_WIDTH, 0)
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.canvas)
end

function VictoryState:getCanvas()
  local p = self.p
  local world = self.world
  local grid = self.grid
  local canvas = love.graphics.newCanvas(WINDOW_HEIGHT, WINDOW_HEIGHT)
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  love.graphics.push()

  love.graphics.translate(p.translate.column * p.size, p.translate.row * p.size)

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, world.columns * p.size, world.rows * p.size)

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

  p:render()

  love.graphics.pop()

  love.graphics.setCanvas()

  return canvas
end
