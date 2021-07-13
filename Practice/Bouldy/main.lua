require "src/Dependencies"

local progressBars
local maze
local player
local direction

local UPDATE_INTERVAL = {
  ["label"] = "update",
  ["duration"] = 0.5
}
local UPDATE_TWEEN = {
  ["duration"] = UPDATE_INTERVAL.duration / 2
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

  Timer:every(
    UPDATE_INTERVAL.duration,
    function()
      Timer:tween(
        UPDATE_TWEEN.duration,
        {
          [player] = {
            ["column"] = player.column + direction.column,
            ["row"] = player.row + direction.row
          }
        }
      )
    end,
    UPDATE_INTERVAL.label
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
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

  if key == "r" then
    maze = Maze:new()
    player = Player:new(maze)

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
  player:render()
end
