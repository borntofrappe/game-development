require "src/Dependencies"

function buildGrid()
  local grid = {}
  for column = 1, COLUMNS do
    grid[column] = {}
    for row = 1, ROWS do
      grid[column][row] = {
        ["column"] = column,
        ["row"] = row,
        ["isAlive"] = math.random(2) == 1,
        ["aliveNeighbors"] = 0
      }
    end
  end

  return grid
end

function step()
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      local c1 = math.max(1, column - 1)
      local c2 = math.min(COLUMNS, column + 1)
      local r1 = math.max(1, row - 1)
      local r2 = math.min(ROWS, row + 1)

      local aliveNeighbors = 0
      for c = c1, c2 do
        for r = r1, r2 do
          if grid[c][r].isAlive and (c ~= column or r ~= row) then
            aliveNeighbors = aliveNeighbors + 1
          end
        end
      end

      grid[column][row].aliveNeighbors = aliveNeighbors
    end
  end

  for column = 1, COLUMNS do
    for row = 1, ROWS do
      local aliveNeighbors = grid[column][row].aliveNeighbors
      local isAlive = grid[column][row].isAlive
      if isAlive then
        if aliveNeighbors < 2 or aliveNeighbors > 3 then
          grid[column][row].isAlive = false
        end
      else
        if aliveNeighbors == 3 then
          grid[column][row].isAlive = true
        end
      end
    end
  end

  generation = generation + 1
end

function love.load()
  love.window.setTitle("Game of Life")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
  love.window.setMode(0, 0)

  -- math.randomseed(os.time())
  width, height = love.graphics.getDimensions()

  font = love.graphics.newFont("res/font.ttf", math.floor(math.min(width, height) / 40))
  love.graphics.setFont(font)

  gridWidth = math.floor(width / 2)
  gridHeight = math.floor(height / 2)

  if gridWidth > gridHeight then
    gridWidth = gridHeight * COLUMNS / ROWS
  else
    gridHeight = gridWidth * ROWS / COLUMNS
  end

  cellSize = gridWidth / COLUMNS

  padding = {
    ["x"] = math.floor((width - gridWidth) / 2),
    ["y"] = math.floor((height - gridHeight) / 2)
  }

  grid = buildGrid()
  generation = 0
  isAnimating = false
  timer = 0

  button = Button:new(0, 0, font:getWidth("Animate") * 1.25, font:getHeight() * 2, "Animate")
end

function love.mousepressed(x, y, button)
  if button == 1 then
    step()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "s" then
    -- step()
  elseif key == "space" then
    isAnimating = isAnimating and false or true
  end
end

function love.update(dt)
  if isAnimating then
    timer = timer + dt
    if timer >= INTERVAL then
      timer = timer % INTERVAL
      step()
    end
  end
end

function love.draw()
  button:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.translate(padding.x, padding.y)

  love.graphics.rectangle("line", 0, 0, gridWidth, gridHeight)
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      if grid[column][row].isAlive then
        love.graphics.rectangle("fill", (column - 1) * cellSize, (row - 1) * cellSize, cellSize, cellSize)
      end
    end
  end

  love.graphics.printf("Generation " .. generation, 0, gridHeight + 16, gridWidth, "center")
end
