WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 50
COLUMNS = 10
ROWS = 10

function love.load()
  love.window.setTitle("Binary Tree")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.95, 0.95, 0.95)

  grid = {}

  player = {
    ["c"] = love.math.random(COLUMNS),
    ["r"] = love.math.random(ROWS)
  }

  cellWidth = (WINDOW_WIDTH - PADDING) / COLUMNS
  cellHeight = (WINDOW_HEIGHT - PADDING) / ROWS

  for c = 1, COLUMNS do
    grid[c] = {}
    for r = 1, ROWS do
      grid[c][r] = {
        ["x0"] = (c - 1) * cellWidth,
        ["y0"] = (r - 1) * cellHeight,
        ["gates"] = {
          ["up"] = {
            ["x1"] = 0,
            ["y1"] = 0,
            ["x2"] = cellWidth,
            ["y2"] = 0
          },
          ["right"] = {
            ["x1"] = cellWidth,
            ["y1"] = 0,
            ["x2"] = cellWidth,
            ["y2"] = cellHeight
          },
          ["down"] = {
            ["x1"] = 0,
            ["y1"] = cellHeight,
            ["x2"] = cellWidth,
            ["y2"] = cellHeight
          },
          ["left"] = {
            ["x1"] = 0,
            ["y1"] = 0,
            ["x2"] = 0,
            ["y2"] = cellHeight
          }
        }
      }
    end
  end

  --[[ binary tree algorithm
    - visit every cell

    - remove the gate north or east

    - do not create any exit
  ]]
  for c = 1, COLUMNS do
    for r = ROWS, 1, -1 do
      local openEast = love.math.random(2) == 1
      if openEast then
        if c < COLUMNS then
          grid[c][r].gates.right = nil
          grid[c + 1][r].gates.left = nil
        else
          if r > 1 then
            grid[c][r - 1].gates.down = nil
            grid[c][r].gates.up = nil
          end
        end
      else
        if r > 1 then
          grid[c][r - 1].gates.down = nil
          grid[c][r].gates.up = nil
        else
          if c < COLUMNS then
            grid[c][r].gates.right = nil
            grid[c + 1][r].gates.left = nil
          end
        end
      end
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "up" then
    if not grid[player.c][player.r].gates.up and player.r > 1 then
      player.r = player.r - 1
    end
  elseif key == "right" then
    if not grid[player.c][player.r].gates.right and player.c < COLUMNS then
      player.c = player.c + 1
    end
  elseif key == "down" then
    if not grid[player.c][player.r].gates.down and player.r < ROWS then
      player.r = player.r + 1
    end
  elseif key == "left" then
    if not grid[player.c][player.r].gates.left and player.c > 1 then
      player.c = player.c - 1
    end
  end
end

function love.draw()
  love.graphics.setColor(0.3, 0.3, 0.3)
  love.graphics.translate(math.floor(PADDING / 2), math.floor(PADDING / 2))
  love.graphics.setLineWidth(5)
  for c = 1, COLUMNS do
    for r = 1, ROWS do
      local cell = grid[c][r]
      for k, gate in pairs(cell.gates) do
        love.graphics.line(cell.x0 + gate.x1, cell.y0 + gate.y1, cell.x0 + gate.x2, cell.y0 + gate.y2)
      end
    end
  end

  love.graphics.circle(
    "fill",
    (player.c - 1) * cellWidth + cellWidth / 2,
    (player.r - 1) * cellHeight + cellHeight / 2,
    math.min(cellWidth, cellHeight) / 4
  )
end
