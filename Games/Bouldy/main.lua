require "src/Dependencies"

function love.load()
  love.window.setTitle("Bouldy")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new()
  local cellSize = maze.grid[1][1].size
  bouldy = Bouldy:new(love.math.random(MAZE_DIMENSION), love.math.random(MAZE_DIMENSION), cellSize, cellSize / 4)

  progressBar =
    ProgressBar:new(
    WINDOW_WIDTH - WINDOW_PADDING - gFonts["normal"]:getWidth("Charge!"),
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Charge!"),
    gFonts["normal"]:getHeight()
  )

  direction = {
    ["column"] = 0,
    ["row"] = 0
  }

  isMoving = false
end

function love.mousepressed(x, y, button)
  if button == 1 then
    maze = Maze:new()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    maze = Maze:new()
  end

  if key == "up" or key == "right" or key == "down" or key == "left" then
    if key == "up" then
      direction.column = 0
      direction.row = -1
    elseif key == "right" then
      direction.column = 1
      direction.row = 0
    elseif key == "down" then
      direction.column = 0
      direction.row = 1
    elseif key == "left" then
      direction.column = -1
      direction.row = 0
    end

    if not isMoving then
      isMoving = true
      Timer:every(
        UPDATE_INTERVAL,
        function()
          local previousColumn = bouldy.column
          local previousRow = bouldy.row

          bouldy.column = math.min(maze.dimension, math.max(1, bouldy.column + direction.column))
          bouldy.row = math.min(maze.dimension, math.max(1, bouldy.row + direction.row))

          if previousColumn == bouldy.column and previousRow == bouldy.row then
            direction.column = 0
            direction.row = 0
            Timer:reset()
            isMoving = false
          else
            Timer:tween(
              0.5,
              {
                [bouldy] = {["x"] = (bouldy.column - 1) * bouldy.size, ["y"] = (bouldy.row - 1) * bouldy.size}
              }
            )
          end
        end,
        true
      )
    end
  end
end

function love.update(dt)
  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.print("Bouldy...charge!", WINDOW_PADDING, WINDOW_PADDING)

  progressBar:render()

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  maze:render()
  bouldy:render()
end
