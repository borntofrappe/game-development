require "src/Dependencies"

local PROGRESS_BAR_LINE_WIDTH = 2
local MAZE_LINE_WIDTH = 3
local MAZE_SIZE = CELL_SIZE * MAZE_DIMENSION
local WINDOW_PADDING = 10
local WINDOW_MARGIN_TOP = 28
local WINDOW_WIDTH = MAZE_SIZE + WINDOW_PADDING * 2
local WINDOW_HEIGHT = MAZE_SIZE + WINDOW_MARGIN_TOP + WINDOW_PADDING * 2

local progressBars
local maze
local player
local coins

local direction
local state = "waiting"

local UPDATE_INTERVAL = {
  ["label"] = "update",
  ["duration"] = 0.5
}

local UPDATE_TWEEN = {
  ["duration"] = 0.3
}

local REPLAY_DELAY = {
  ["duration"] = 3
}

local KEYS_DIRECTION = {
  ["c0r-1"] = "up",
  ["c1r0"] = "right",
  ["c0r1"] = "down",
  ["c-1r0"] = "left"
}

local GATES_DIRECTION = {
  ["up"] = {"up", "down"},
  ["right"] = {"right", "left"},
  ["down"] = {"down", "up"},
  ["left"] = {"left", "right"}
}

local SPEED_INCREMENT = 0.2

function love.load()
  love.window.setTitle(TITLE)
  math.randomseed(os.time())

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(COLORS.background.r, COLORS.background.g, COLORS.background.b)

  gFonts = {
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  gSounds = {
    ["bounce"] = love.audio.newSource("res/sounds/bounce.wav", "static"),
    ["collect"] = love.audio.newSource("res/sounds/collect.wav", "static"),
    ["destroy"] = love.audio.newSource("res/sounds/destroy.wav", "static"),
    ["move"] = love.audio.newSource("res/sounds/move.wav", "static"),
    ["power-up"] = love.audio.newSource("res/sounds/power-up.wav", "static"),
    ["win"] = love.audio.newSource("res/sounds/win.wav", "static")
  }

  maze = Maze:new()
  player = Player:new(maze)
  coins = Coins:new(maze, player)

  local PROGRESS_BAR_HEIGHT = WINDOW_MARGIN_TOP - WINDOW_PADDING
  local PROGRESS_BAR_WIDTH = (WINDOW_WIDTH - WINDOW_PADDING * 2 - gFonts.normal:getWidth("\t" .. TITLE .. "\t")) / 2

  progressBars = {
    ["coins"] = ProgressBar:new(
      WINDOW_PADDING,
      WINDOW_PADDING,
      PROGRESS_BAR_WIDTH,
      PROGRESS_BAR_HEIGHT,
      COLORS.maze,
      COLORS.coin,
      0
    ),
    ["speed"] = ProgressBar:new(
      WINDOW_WIDTH - WINDOW_PADDING - PROGRESS_BAR_WIDTH,
      WINDOW_PADDING,
      PROGRESS_BAR_WIDTH,
      PROGRESS_BAR_HEIGHT,
      COLORS.maze,
      COLORS.speed,
      0
    )
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" or key == "right" or key == "down" or key == "left" then
    if state == "waiting" then
      state = "playing"
      Timer:every(
        UPDATE_INTERVAL.duration,
        function()
          gSounds["move"]:play()

          local canMove = true
          local canDestroy = false

          local keyDirection = "c" .. player.direction.column .. "r" .. player.direction.row

          if KEYS_DIRECTION[keyDirection] and maze.grid[player.column][player.row].gates[KEYS_DIRECTION[keyDirection]] then
            if progressBars["speed"].progress == 1 then
              canDestroy = true
            else
              canMove = false
              gSounds["bounce"]:play()
            end
          end

          local column = player.column + player.direction.column
          local row = player.row + player.direction.row

          if column < 1 or column > maze.columns or row < 1 or row > maze.rows then
            canMove = false
          end

          player:animateMovement(KEYS_DIRECTION[keyDirection])

          if canMove then
            local speedProgress = math.min(1, progressBars["speed"].progress + SPEED_INCREMENT)
            if canDestroy then
              gSounds["destroy"]:play()

              speedProgress = math.max(0, speedProgress - SPEED_INCREMENT * math.random(1 / SPEED_INCREMENT))

              local cell = maze.grid[player.column][player.row]
              local neighboringCell = maze.grid[column][row]

              local direction = KEYS_DIRECTION[keyDirection]
              local gateCell = cell.gates[GATES_DIRECTION[direction][1]]
              local gateNeighboringCell = neighboringCell.gates[GATES_DIRECTION[direction][2]]

              cell.gates[GATES_DIRECTION[direction][1]] = nil
              neighboringCell.gates[GATES_DIRECTION[direction][2]] = nil

              maze:animateDestruction((gateCell.x1 + gateCell.x2) / 2, (gateCell.y1 + gateCell.y2) / 2, direction)

              Timer:after(
                UPDATE_TWEEN.duration,
                function()
                  cell.gates[GATES_DIRECTION[direction][1]] = gateCell
                  neighboringCell.gates[GATES_DIRECTION[direction][2]] = gateNeighboringCell
                end
              )
            end

            Timer:tween(
              UPDATE_TWEEN.duration,
              {
                [player] = {
                  ["column"] = column,
                  ["row"] = row
                },
                [progressBars["speed"]] = {
                  ["progress"] = speedProgress
                }
              },
              function()
                if progressBars["speed"].progress == 1 then
                  if player.fill ~= progressBars["speed"].fill then
                    gSounds["power-up"]:play()
                  end
                  player:setFill(progressBars["speed"].fill)
                else
                  player:setFill(COLORS.player)
                end

                local hasCoin = false
                for k, coin in pairs(coins.coins) do
                  if player.column == coin.column and player.row == coin.row then
                    table.remove(coins.coins, k)
                    hasCoin = true
                    break
                  end
                end

                local hasAllCoins = #coins.coins == 0
                if hasAllCoins then
                  Timer:remove(UPDATE_INTERVAL.label)
                end

                if hasCoin then
                  gSounds["collect"]:play()

                  Timer:tween(
                    UPDATE_TWEEN.duration,
                    {
                      [progressBars["coins"]] = {["progress"] = 1 - #coins.coins / COINS}
                    },
                    function()
                      if hasAllCoins then
                        gSounds["win"]:play()

                        player:setFill(COLORS.coin)

                        Timer:after(
                          REPLAY_DELAY.duration,
                          function()
                            gSounds["destroy"]:play()

                            player:setFill(COLORS.player)

                            for k, column in pairs(maze.grid) do
                              for j, cell in pairs(column) do
                                for h, gate in pairs(cell.gates) do
                                  maze:animateDestruction((gate.x1 + gate.x2) / 2, (gate.y1 + gate.y2) / 2)
                                  cell.gates[h] = nil
                                end
                              end
                            end

                            Timer:tween(
                              UPDATE_TWEEN.duration,
                              {
                                [progressBars["coins"]] = {["progress"] = 0},
                                [progressBars["speed"]] = {["progress"] = 0}
                              },
                              function()
                                state = "waiting"
                                player:stop()
                                maze = Maze:new()
                                coins = Coins:new(maze, player)
                              end
                            )
                          end
                        )
                      end
                    end
                  )
                end
              end
            )
          else
            Timer:remove(UPDATE_INTERVAL.label)
            local column = player.column
            local row = player.row

            Timer:tween(
              UPDATE_TWEEN.duration / 2,
              {
                [player] = {
                  ["column"] = player.column + player.direction.column * player.paddingPercentage,
                  ["row"] = player.row + player.direction.row * player.paddingPercentage
                },
                [progressBars["speed"]] = {
                  ["progress"] = math.min(1, progressBars["speed"].progress + SPEED_INCREMENT / 2)
                }
              },
              function()
                Timer:tween(
                  UPDATE_TWEEN.duration / 2,
                  {
                    [player] = {
                      ["column"] = column,
                      ["row"] = row
                    },
                    [progressBars["speed"]] = {
                      ["progress"] = 0
                    }
                  },
                  function()
                    state = "waiting"
                    player:stop()
                  end
                )
              end
            )
          end
        end,
        true,
        UPDATE_INTERVAL.label
      )
    end

    if key == "up" then
      player.direction.column = 0
      player.direction.row = -1
    elseif key == "right" then
      player.direction.column = 1
      player.direction.row = 0
    elseif key == "down" then
      player.direction.column = 0
      player.direction.row = 1
    elseif key == "left" then
      player.direction.column = -1
      player.direction.row = 0
    end
  end
end

function love.update(dt)
  maze:update(dt)
  player:update(dt)

  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(TITLE, 0, WINDOW_MARGIN_TOP - gFonts.normal:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.setLineWidth(PROGRESS_BAR_LINE_WIDTH)
  for k, progressBar in pairs(progressBars) do
    progressBar:render()
  end

  love.graphics.setLineWidth(MAZE_LINE_WIDTH)
  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  maze:render()
  coins:render()
  player:render()
end
