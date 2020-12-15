require "src/Dependencies"

function getCoins(dimension, skipColumn, skipRow)
  local coins = {}
  while #coins < COINS_MAX do
    local hasOverlap = false

    local column = love.math.random(dimension)
    local row = love.math.random(dimension)

    if column == skipColumn and row == skipRow then
      hasOverlap = true
    else
      for i, coin in ipairs(coins) do 
        if column == coin.column and row == coin.row then 
          hasOverlap = true 
          break
        end
      end
    end

    if not hasOverlap then
      local coin = Coin:new(column, row, maze.cellSize, maze.cellSize / 3)
      table.insert(coins, coin)
    end
  end

  return coins
end

function love.load()
  love.window.setTitle("Bouldy")

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  maze = Maze:new()

  bouldy =
    Bouldy:new(love.math.random(MAZE_DIMENSION), love.math.random(MAZE_DIMENSION), maze.cellSize, maze.cellSize / 4)

  coins = getCoins(MAZE_DIMENSION, bouldy.column, bouldy.row)

  progressBarCoins =
    ProgressBar:new(
    WINDOW_PADDING,
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Bouldy"),
    gFonts["normal"]:getHeight(),
    COINS_INITIAL,
    COINS_MAX,
    COINS_MAX,
    "coin"
  )

  progressBarSpeed =
    ProgressBar:new(
    WINDOW_WIDTH - WINDOW_PADDING - gFonts["normal"]:getWidth("Bouldy"),
    WINDOW_PADDING,
    gFonts["normal"]:getWidth("Bouldy"),
    gFonts["normal"]:getHeight(),
    PROGRESS_INITIAL,
    PROGRESS_MAX,
    PROGRESS_STEPS,
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

  isUpdating = false
  isGameOver = false
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
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

    if not isUpdating then
      isUpdating = true
      Timer:every(
        UPDATE_INTERVAL,
        function()
          if not isGameOver then
            gSounds["bouldy"]:play()
            -- at an interval pick the value described by the direction table to change the movement of bouldy
            local d = {
              ["column"] = bouldy.direction.column,
              ["row"] = bouldy.direction.row
            }
            -- controlling variable to describe if bouldy hits a wall/gate
            local hasBounced = false
            -- integers to restore the position in the grid if necessary
            local previousColumn = bouldy.column
            local previousRow = bouldy.row
            -- cells matching the position of bouldy, before and after the movement
            local previousCell = maze.grid[previousColumn][previousRow]
            local cell = maze.grid[bouldy.column][bouldy.row]

            -- MOVE BOULDY IN THE MAZE
            -- ! remember to revert the operation if bouldy bounces against a wall
            bouldy.column = math.min(maze.dimension, math.max(1, bouldy.column + d.column))
            bouldy.row = math.min(maze.dimension, math.max(1, bouldy.row + d.row))

            -- EMIT DUST PARTICLES
            -- + / 4 to compensate for the movement already taking place
            local particleSytemDustX = bouldy.x + bouldy.size / 2 + bouldy.size / 4 * d.column
            local particleSytemDustY = bouldy.y + bouldy.size / 2 + bouldy.size / 4 * d.row

            particleSystemDust:setPosition(particleSytemDustX, particleSytemDustY)
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

            -- CONSIDER WALL/ GATES
            --[[
            hitting a wall column and row are already considered by math.max/math.min
            hitting a gate it is necessary to revert the operation
          
            gates and gatePair are used to consider the gate being hit
            the idea is to remove the gate with enough speed
          ]]
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

            -- if bouncing animate bouldy toward the wall/gate and back
            -- move faster in the first segment (see UPDATE_FRACTION)
            if hasBounced then
              -- FIRST MOVEMENT
              Timer:tween(
                UPDATE_TWEEN * UPDATE_FRACTION,
                {
                  [bouldy] = {
                    ["x"] = (bouldy.column - 1) * bouldy.size + d.column * bouldy.padding,
                    ["y"] = (bouldy.row - 1) * bouldy.size + d.row * bouldy.padding
                  },
                  [progressBarSpeed.progress] = {
                    ["value"] = math.min(
                      progressBarSpeed.progress.max,
                      progressBarSpeed.progress.value + math.floor(progressBarSpeed.progress.step * UPDATE_FRACTION)
                    )
                  }
                }
              )
              Timer:after(
                UPDATE_TWEEN * UPDATE_FRACTION,
                function()
                  bouldy.x = (bouldy.column - 1) * bouldy.size + d.column * bouldy.padding
                  bouldy.y = (bouldy.row - 1) * bouldy.size + d.row * bouldy.padding
                  progressBarSpeed.progress.value =
                    math.min(
                    progressBarSpeed.progress.max,
                    progressBarSpeed.progress.value + math.floor(progressBarSpeed.progress.step * UPDATE_FRACTION)
                  )

                  -- SECOND MOVEMENT
                  -- let bouldy through when the speed bar describes the maximum value
                  -- ! only for a gate
                  if gatePair and progressBarSpeed.progress.value == progressBarSpeed.progress.max then
                    -- ! repeat the movement erased when checking a gate
                    bouldy.column = math.min(maze.dimension, math.max(1, bouldy.column + d.column))
                    bouldy.row = math.min(maze.dimension, math.max(1, bouldy.row + d.row))

                    -- ! keep a reference to the gate to restore the value after bouldy gets through
                    local previousGate = previousCell.gates[gatePair[1]]
                    local gate = cell.gates[gatePair[2]]

                    gSounds["gate"]:play()
                    previousCell.gates[gatePair[1]] = nil
                    cell.gates[gatePair[2]] = nil

                    -- EMIT DEBRIS PARTICLES
                    local particleSystemDebrisX =
                      (previousCell.column - 1) * previousCell.size + (previousGate.x1 + previousGate.x2) / 2
                    local particleSystemDebrisY =
                      (previousCell.row - 1) * previousCell.size + (previousGate.y1 + previousGate.y2) / 2

                    particleSystemDebris:setPosition(particleSystemDebrisX, particleSystemDebrisY)
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

                    -- stepsDecrease to randomly decrease the speed bar
                    local stepsDecrease = love.math.random(PROGRESS_STEPS)
                    particleSystemDebris:emit(PARTICLE_SYSTEM_DEBRIS_PARTICLES * stepsDecrease)

                    -- COMPLETE SECOND MOVEMENT THROUGH
                    Timer:tween(
                      UPDATE_TWEEN * (1 - UPDATE_FRACTION),
                      {
                        [bouldy] = {["x"] = (bouldy.column - 1) * bouldy.size, ["y"] = (bouldy.row - 1) * bouldy.size},
                        [progressBarSpeed.progress] = {
                          ["value"] = progressBarSpeed.progress.value - (progressBarSpeed.progress.step) * stepsDecrease
                        }
                      }
                    )

                    -- UPDATE GAME by restoring the gates/checking for coins
                    Timer:after(
                      UPDATE_TWEEN * (1 - UPDATE_FRACTION),
                      function()
                        progressBarSpeed.colorStroke = "light"
                        bouldy.colorFill = "light"

                        previousCell.gates[gatePair[1]] = previousGate
                        cell.gates[gatePair[2]] = gate

                        -- use a boolean to conditionally update the progress bar for the coins/checking if all coins are collected
                        local hasCoin = false

                        for i = #coins, 1, -1 do
                          if coins[i].column == bouldy.column and coins[i].row == bouldy.row then
                            table.remove(coins, i)
                            hasCoin = true
                            break
                          end
                        end

                        if hasCoin then
                          gSounds["coin"]:play()
                          Timer:tween(
                            UPDATE_TWEEN,
                            {
                              [progressBarCoins.progress] = {
                                ["value"] = COINS_MAX - #coins
                              }
                            }
                          )

                          if #coins == 0 then
                            isGameOver = true
                          end
                        end
                      end
                    )
                  else
                    -- COMPLETE SECOND MOVEMENT BACK
                    gSounds["bounce"]:play()
                    progressBarSpeed.colorStroke = "light"
                    bouldy.colorFill = "light"

                    Timer:tween(
                      UPDATE_TWEEN * (1 - UPDATE_FRACTION),
                      {
                        [bouldy] = {
                          ["x"] = (bouldy.column - 1) * bouldy.size,
                          ["y"] = (bouldy.row - 1) * bouldy.size
                        },
                        -- tweeing the bar speed to 0 has an annoying rounding error
                        [progressBarSpeed.progress] = {
                          ["value"] = 5
                        }
                      }
                    )

                    -- UPDATE GAME by stopping bouldy
                    Timer:after(
                      UPDATE_TWEEN * (1 - UPDATE_FRACTION),
                      function()
                        d.column = 0
                        d.row = 0

                        bouldy.x = (bouldy.column - 1) * bouldy.size
                        bouldy.y = (bouldy.row - 1) * bouldy.size
                        progressBarSpeed.progress.value = 0
                        Timer.intervals = {}
                        isUpdating = false
                      end
                    )
                  end
                end
              )
            else
              -- NOT BOUNCING
              -- move bouldy in a single motion toward the new cell
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

              -- UPDATE GAME by highlighting if the speed bar reaches the max value and checking for coins
              Timer:after(
                UPDATE_TWEEN,
                function()
                  if math.ceil(progressBarSpeed.progress.value) == progressBarSpeed.progress.max then
                    if bouldy.colorFill ~= "speed" then
                      gSounds["speed"]:play()
                    end
                    progressBarSpeed.colorStroke = "speed"
                    bouldy.colorFill = "speed"
                  end

                  -- same operation for when bouldy gets through a wall
                  local hasCoin = false

                  for i = #coins, 1, -1 do
                    if coins[i].column == bouldy.column and coins[i].row == bouldy.row then
                      table.remove(coins, i)
                      hasCoin = true
                      break
                    end
                  end

                  if hasCoin then
                    gSounds["coin"]:play()
                    Timer:tween(
                      UPDATE_TWEEN,
                      {
                        [progressBarCoins.progress] = {
                          ["value"] = COINS_MAX - #coins
                        }
                      }
                    )

                    if #coins == 0 then
                      isGameOver = true
                    end
                  end
                end
              )
            end
          else
            -- GAMEOVER
            -- remove interval before highlighting the gameover through the progress bars
            gSounds["gameover"]:play()
            Timer.intervals = {}
            progressBarCoins.colorStroke = "coin"
            bouldy.colorFill = "coin"

            -- reset game with new coins/ progress values
            Timer:after(
              GAMEOVER_DELAY,
              function()
                Timer:tween(
                  UPDATE_TWEEN,
                  {
                    [progressBarSpeed.progress] = {["value"] = 0},
                    [progressBarCoins.progress] = {["value"] = 0}
                  }
                )

                Timer:after(
                  UPDATE_TWEEN,
                  function()
                    maze = Maze:new()
                    coins = getCoins(maze.dimension, bouldy.column, bouldy.row)
                    progressBarSpeed.colorStroke = "light"
                    progressBarCoins.colorStroke = "light"
                    bouldy.colorFill = "light"
                    isUpdating = false
                    isGameOver = false
                  end
                )
              end
            )
          end
        end,
        -- execute the callback immediately
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
  love.graphics.printf("Bouldy", 0, WINDOW_PADDING + 2, WINDOW_WIDTH, "center")

  progressBarCoins:render()
  progressBarSpeed:render()

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)

  maze:render()

  -- color the particle systems with bouldy's fill
  love.graphics.setColor(gColors[bouldy.colorFill].r, gColors[bouldy.colorFill].g, gColors[bouldy.colorFill].b)
  love.graphics.draw(particleSystemDust)
  love.graphics.draw(particleSystemDebris)

  for i, coin in ipairs(coins) do
    coin:render()
  end

  bouldy:render()
end
