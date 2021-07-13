require "src/Dependencies"

local progressBars
local maze
local player
local direction
local isMoving

local coins

local UPDATE_INTERVAL = {
  ["label"] = "update",
  ["duration"] = 0.5
}
local UPDATE_TWEEN = {
  ["duration"] = 0.3
}

local KEYS_DIRECTION = {
  ["c0r-1"] = "up",
  ["c1r0"] = "right",
  ["c0r1"] = "down",
  ["c-1r0"] = "left"
}

function love.load()
  love.window.setTitle(TITLE)
  math.randomseed(os.time())

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  gFonts = {
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  local PROGRESS_BAR_HEIGHT = WINDOW_MARGIN_TOP - WINDOW_PADDING
  local PROGRESS_BAR_WIDTH = (WINDOW_WIDTH - WINDOW_PADDING * 2 - gFonts.normal:getWidth("\t" .. TITLE .. "\t")) / 2

  maze = Maze:new()
  player = Player:new(maze)
  coins = Coins:new(maze)

  direction = {
    ["column"] = 0,
    ["row"] = 0
  }

  progressBars = {
    ["coins"] = ProgressBar:new(
      WINDOW_PADDING,
      WINDOW_PADDING,
      PROGRESS_BAR_WIDTH,
      PROGRESS_BAR_HEIGHT,
      {
        ["r"] = 1,
        ["g"] = 1,
        ["b"] = 1
      },
      {
        ["r"] = 0.92,
        ["g"] = 0.82,
        ["b"] = 0.07
      },
      0
    ),
    ["speed"] = ProgressBar:new(
      WINDOW_WIDTH - WINDOW_PADDING - PROGRESS_BAR_WIDTH,
      WINDOW_PADDING,
      PROGRESS_BAR_WIDTH,
      PROGRESS_BAR_HEIGHT,
      {
        ["r"] = 1,
        ["g"] = 1,
        ["b"] = 1
      },
      {
        ["r"] = 0.19,
        ["g"] = 0.82,
        ["b"] = 0.67
      },
      0
    )
  }
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "up" or key == "right" or key == "down" or key == "left" then
    if not isMoving then
      isMoving = true
      Timer:every(
        UPDATE_INTERVAL.duration,
        function()
          local canMove = true

          local keyDirection = "c" .. direction.column .. "r" .. direction.row

          if KEYS_DIRECTION[keyDirection] and maze.grid[player.column][player.row].gates[KEYS_DIRECTION[keyDirection]] then
            canMove = false
          end

          local column = player.column + direction.column
          local row = player.row + direction.row

          if column < 1 or column > maze.columns or row < 1 or row > maze.rows then
            canMove = false
          end

          if canMove then
            Timer:tween(
              UPDATE_TWEEN.duration,
              {
                [player] = {
                  ["column"] = column,
                  ["row"] = row
                }
              },
              function()
                local hasCoin = false
                for k, coin in pairs(coins.coins) do
                  if player.column == coin.column and player.row == coin.row then
                    table.remove(coins.coins, k)
                    hasCoin = true
                    break
                  end
                end
                if hasCoin then
                  Timer:tween(
                    UPDATE_TWEEN.duration,
                    {
                      [progressBars["coins"]] = {["progress"] = 1 - #coins.coins / COINS}
                    }
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
                  ["column"] = player.column + direction.column * player.paddingPercentage,
                  ["row"] = player.row + direction.row * player.paddingPercentage
                }
              },
              function()
                Timer:tween(
                  UPDATE_TWEEN.duration / 2,
                  {
                    [player] = {
                      ["column"] = column,
                      ["row"] = row
                    }
                  },
                  function()
                    direction.column = 0
                    direction.row = 0
                    isMoving = false
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
  end

  if key == "r" then
    maze = Maze:new()
    player = Player:new(maze)
    coins = Coins:new(maze)
    progressBars["coins"].progress = 0

    direction = {
      ["column"] = 0,
      ["row"] = 0
    }
  end
end

function love.update(dt)
  Timer:update(dt)
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(TITLE, 0, WINDOW_MARGIN_TOP - gFonts.normal:getHeight() + 1, WINDOW_WIDTH, "center")

  love.graphics.setLineWidth(2)
  for k, progressBar in pairs(progressBars) do
    progressBar:render()
  end

  love.graphics.translate(WINDOW_PADDING, WINDOW_PADDING + WINDOW_MARGIN_TOP)
  maze:render()
  coins:render()
  player:render()
end
