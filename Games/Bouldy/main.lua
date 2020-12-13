require "src/Dependencies"

function love.load()
  love.window.setTitle("Bouldy")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new()
  bouldy =
    Bouldy:new(love.math.random(MAZE_DIMENSION), love.math.random(MAZE_DIMENSION), maze.cellSize, maze.cellSize / 4)

  progressBar =
    ProgressBar:new(
    WINDOW_WIDTH - WINDOW_PADDING - gFonts["normal"]:getWidth("Charge!"),
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Charge!"),
    gFonts["normal"]:getHeight()
  )
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
    local direction = {
      ["column"] = 0,
      ["row"] = 0
    }
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

    bouldy.direction.column = direction.column
    bouldy.direction.row = direction.row

    if not bouldy.isMoving then
      bouldy.isMoving = true
      local d = bouldy.direction
      Timer:every(
        UPDATE_INTERVAL,
        function()
          local previousColumn = bouldy.column
          local previousRow = bouldy.row

          local hasBounced = false

          bouldy.column = math.min(maze.dimension, math.max(1, bouldy.column + d.column))
          bouldy.row = math.min(maze.dimension, math.max(1, bouldy.row + d.row))

          if previousColumn == bouldy.column and previousRow == bouldy.row then
            hasBounced = true
          end

          local gates = {
            ["0-1"] = "up",
            ["10"] = "right",
            ["01"] = "down",
            ["-10"] = "left"
          }

          if not hasBounced and maze.grid[previousColumn][previousRow].gates[gates[d.column .. d.row]] then
            hasBounced = true
            bouldy.column = previousColumn
            bouldy.row = previousRow
          end

          if hasBounced then
            Timer:tween(
              UPDATE_TWEEN / 5,
              {
                [bouldy] = {
                  ["x"] = (bouldy.column - 1) * bouldy.size + d.column * bouldy.padding,
                  ["y"] = (bouldy.row - 1) * bouldy.size + d.row * bouldy.padding
                },
                [progressBar.progress] = {
                  ["value"] = math.min(
                    progressBar.progress.max,
                    progressBar.progress.value + math.floor(progressBar.progress.step / 5)
                  )
                }
              }
            )
            Timer:after(
              UPDATE_TWEEN / 5,
              function()
                -- precautionary
                bouldy.x = (bouldy.column - 1) * bouldy.size + d.column * bouldy.padding
                bouldy.y = (bouldy.row - 1) * bouldy.size + d.row * bouldy.padding
                progressBar.progress.value =
                  math.min(
                  progressBar.progress.max,
                  progressBar.progress.value + math.floor(progressBar.progress.step / 5)
                )

                Timer:tween(
                  UPDATE_TWEEN / 5 * 4,
                  {
                    [bouldy] = {
                      ["x"] = (bouldy.column - 1) * bouldy.size,
                      ["y"] = (bouldy.row - 1) * bouldy.size
                    },
                    [progressBar.progress] = {
                      ["value"] = 0
                    }
                  }
                )
                Timer:after(
                  UPDATE_TWEEN / 5 * 4,
                  function()
                    d.column = 0
                    d.row = 0
                    -- precautionary
                    bouldy.x = (bouldy.column - 1) * bouldy.size
                    bouldy.y = (bouldy.row - 1) * bouldy.size
                    progressBar.progress.value = 0
                    Timer:reset()
                    bouldy.isMoving = false
                  end
                )
              end
            )
          else
            Timer:tween(
              UPDATE_TWEEN,
              {
                [bouldy] = {["x"] = (bouldy.column - 1) * bouldy.size, ["y"] = (bouldy.row - 1) * bouldy.size},
                [progressBar.progress] = {
                  ["value"] = math.min(progressBar.progress.max, progressBar.progress.value + progressBar.progress.step)
                }
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
  love.graphics.print("Bouldy", WINDOW_PADDING, WINDOW_PADDING)

  progressBar:render()

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  maze:render()
  bouldy:render()
end
