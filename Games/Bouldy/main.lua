require "src/Dependencies"

function love.load()
  love.window.setTitle("Bouldy")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new()
  bouldy =
    Bouldy:new(love.math.random(MAZE_DIMENSION), love.math.random(MAZE_DIMENSION), maze.cellSize, maze.cellSize / 4)

  progressBarCoins =
    ProgressBar:new(
    WINDOW_PADDING,
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Bouldy"),
    gFonts["normal"]:getHeight(),
    "coins"
  )

  progressBarSpeed =
    ProgressBar:new(
    WINDOW_WIDTH - WINDOW_PADDING - gFonts["normal"]:getWidth("Bouldy"),
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Bouldy"),
    gFonts["normal"]:getHeight(),
    "speed"
  )

  particleSystemDust = love.graphics.newParticleSystem(gTextures["particle-dust"], PARTICLE_SYSTEM_DUST_BUFFER)
  particleSystemDust:setParticleLifetime(PARTICLE_SYSTEM_DUST_LIFETIME_MIN, PARTICLE_SYSTEM_DUST_LIFETIME_MAX)
  particleSystemDust:setRadialAcceleration(
    PARTICLE_SYSTEM_DUST_RADIAL_ACCELERATION[1],
    PARTICLE_SYSTEM_DUST_RADIAL_ACCELERATION[2]
  )
  particleSystemDust:setColors(1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0)

  particleSystemDebris = love.graphics.newParticleSystem(gTextures["particle-debris"], PARTICLE_SYSTEM_DEBRIS_BUFFER)
  particleSystemDebris:setParticleLifetime(PARTICLE_SYSTEM_DEBRIS_LIFETIME_MIN, PARTICLE_SYSTEM_DEBRIS_LIFETIME_MAX)
  particleSystemDebris:setRadialAcceleration(
    PARTICLE_SYSTEM_DEBRIS_RADIAL_ACCELERATION[1],
    PARTICLE_SYSTEM_DEBRIS_RADIAL_ACCELERATION[2]
  )
  particleSystemDebris:setSpin(0, math.pi * 2)
  particleSystemDebris:setRotation(0, math.pi * 2)
  particleSystemDebris:setSizes(0, 1, 1, 1, 0)
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
      Timer:every(
        UPDATE_INTERVAL,
        function()
          -- d = bouldy.direction would not work as intended, as the table would be modified between tweens
          local d = {
            ["column"] = bouldy.direction.column,
            ["row"] = bouldy.direction.row
          }
          local previousColumn = bouldy.column
          local previousRow = bouldy.row

          local hasBounced = false

          bouldy.column = math.min(maze.dimension, math.max(1, bouldy.column + d.column))
          bouldy.row = math.min(maze.dimension, math.max(1, bouldy.row + d.row))

          local previousCell = maze.grid[previousColumn][previousRow]
          local cell = maze.grid[bouldy.column][bouldy.row]

          -- + / 4 to compensate for the movement
          local x = bouldy.x + bouldy.size / 2 + bouldy.size / 4 * d.column
          local y = bouldy.y + bouldy.size / 2 + bouldy.size / 4 * d.row

          particleSystemDust:setPosition(x, y)
          local min = PARTICLE_SYSTEM_DUST_LINEAR_ACCELERATION[1]
          local max = PARTICLE_SYSTEM_DUST_LINEAR_ACCELERATION[2]
          local xMin, xMax, yMin, yMax

          if d.column == 0 then
            xMin = min
            xMax = max

            yMin = max * d.row * -1
            yMax = max * d.row * -1 * 2
          else
            xMin = max * d.column * -1
            xMax = max * d.column * -1 * 2

            yMin = min
            yMax = max
          end
          particleSystemDust:setLinearAcceleration(xMin, yMin, xMax, yMax)

          particleSystemDust:emit(PARTICLE_SYSTEM_DUST_PARTICLES)

          local gates = {
            ["0-1"] = {"up", "down"},
            ["10"] = {"right", "left"},
            ["01"] = {"down", "up"},
            ["-10"] = {"left", "right"}
          }
          local gatePair

          if previousColumn == bouldy.column and previousRow == bouldy.row then
            hasBounced = true
          else
            gatePair = gates[d.column .. d.row]
            if previousCell.gates[gatePair[1]] then
              hasBounced = true
              bouldy.column = previousColumn
              bouldy.row = previousRow
            end
          end

          if hasBounced then
            Timer:tween(
              UPDATE_TWEEN / 5,
              {
                [bouldy] = {
                  ["x"] = (bouldy.column - 1) * bouldy.size + d.column * bouldy.padding,
                  ["y"] = (bouldy.row - 1) * bouldy.size + d.row * bouldy.padding
                },
                [progressBarSpeed.progress] = {
                  ["value"] = math.min(
                    progressBarSpeed.progress.max,
                    progressBarSpeed.progress.value + math.floor(progressBarSpeed.progress.step / 5)
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
                progressBarSpeed.progress.value =
                  math.min(
                  progressBarSpeed.progress.max,
                  progressBarSpeed.progress.value + math.floor(progressBarSpeed.progress.step / 5)
                )

                if gatePair and progressBarSpeed.progress.value == progressBarSpeed.progress.max then
                  bouldy.column = math.min(maze.dimension, math.max(1, bouldy.column + d.column))
                  bouldy.row = math.min(maze.dimension, math.max(1, bouldy.row + d.row))

                  local previousGate = previousCell.gates[gatePair[1]]
                  local gate = cell.gates[gatePair[2]]

                  previousCell.gates[gatePair[1]] = nil
                  cell.gates[gatePair[2]] = nil

                  local x = (previousCell.column - 1) * previousCell.size + (previousGate.x1 + previousGate.x2) / 2
                  local y = (previousCell.row - 1) * previousCell.size + (previousGate.y1 + previousGate.y2) / 2

                  particleSystemDebris:setPosition(x, y)
                  particleSystemDebris:setEmissionArea(
                    "uniform",
                    (previousGate.x1 + previousGate.x2) / 2 / 2,
                    (previousGate.y1 + previousGate.y2) / 2 / 2
                  )

                  local min = PARTICLE_SYSTEM_DEBRIS_LINEAR_ACCELERATION[1]
                  local max = PARTICLE_SYSTEM_DEBRIS_LINEAR_ACCELERATION[2]
                  local xMin, xMax, yMin, yMax

                  if d.column == 0 then
                    xMin = min
                    xMax = max

                    yMin = max * d.row
                    yMax = max * d.row * 2
                  else
                    xMin = max * d.column
                    xMax = max * d.column * 2

                    yMin = min
                    yMax = max
                  end
                  particleSystemDebris:setLinearAcceleration(xMin, yMin, xMax, yMax)

                  particleSystemDebris:emit(PARTICLE_SYSTEM_DEBRIS_PARTICLES)

                  Timer:tween(
                    UPDATE_TWEEN / 5 * 4,
                    {
                      [bouldy] = {["x"] = (bouldy.column - 1) * bouldy.size, ["y"] = (bouldy.row - 1) * bouldy.size},
                      [progressBarSpeed.progress] = {
                        ["value"] = progressBarSpeed.progress.value - progressBarSpeed.progress.step
                      }
                    }
                  )

                  Timer:after(
                    UPDATE_TWEEN / 5 * 4,
                    function()
                      progressBarSpeed.colorStroke = "light"
                      bouldy.colorFill = "light"
                      previousCell.gates[gatePair[1]] = previousGate
                      cell.gates[gatePair[2]] = gate
                    end
                  )
                else
                  progressBarSpeed.colorStroke = "light"
                  bouldy.colorFill = "light"
                  Timer:tween(
                    UPDATE_TWEEN / 5 * 4,
                    {
                      [bouldy] = {
                        ["x"] = (bouldy.column - 1) * bouldy.size,
                        ["y"] = (bouldy.row - 1) * bouldy.size
                      },
                      -- ???
                      [progressBarSpeed.progress] = {
                        ["value"] = 5
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
                      progressBarSpeed.progress.value = 0
                      Timer:reset()
                      bouldy.isMoving = false
                    end
                  )
                end
              end
            )
          else
            Timer:tween(
              UPDATE_TWEEN,
              {
                [bouldy] = {["x"] = (bouldy.column - 1) * bouldy.size, ["y"] = (bouldy.row - 1) * bouldy.size},
                [progressBarSpeed.progress] = {
                  ["value"] = math.min(
                    progressBarSpeed.progress.max,
                    progressBarSpeed.progress.value + progressBarSpeed.progress.step
                  )
                }
              }
            )
            Timer:after(
              UPDATE_TWEEN,
              function()
                if math.ceil(progressBarSpeed.progress.value) == progressBarSpeed.progress.max then
                  progressBarSpeed.colorStroke = "speed"
                  bouldy.colorFill = "speed"
                end
              end
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
  particleSystemDust:update(dt)
  particleSystemDebris:update(dt)
end

function love.draw()
  love.graphics.setColor(gColors["light"].r, gColors["light"].g, gColors["light"].b)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Bouldy", 0, WINDOW_PADDING, WINDOW_WIDTH, "center")

  progressBarCoins:render()
  progressBarSpeed:render()

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  maze:render()

  love.graphics.setColor(gColors[bouldy.colorFill].r, gColors[bouldy.colorFill].g, gColors[bouldy.colorFill].b)
  love.graphics.draw(particleSystemDust)
  love.graphics.draw(particleSystemDebris)

  bouldy:render()
end
