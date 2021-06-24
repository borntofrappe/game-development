require "src/Dependencies"

-- level * points per lines up to 4
local SCORE_PER_LINES = {
  [1] = 40,
  [2] = 100,
  [3] = 300,
  [4] = 1200
}

local grid = Grid:new()
local tetromino = Tetromino:new()
local gamedata = Gamedata:new()
local interval = 0.8
local time = 0
local state = "playing"

function love.load()
  love.window.setTitle("Tetris")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = true,
      vsync = true
    }
  )

  gFont = love.graphics.newFont("res/fonts/font.ttf", 8)

  gColors = {
    {["r"] = 0.22, ["g"] = 0.22, ["b"] = 0.16},
    {["r"] = 0.48, ["g"] = 0.44, ["b"] = 0.38},
    {["r"] = 0.71, ["g"] = 0.63, ["b"] = 0.41},
    {["r"] = 0.9, ["g"] = 0.82, ["b"] = 0.61}
  }

  gTexture = love.graphics.newImage("res/graphics/spritesheet.png")
  gFrames = GenerateQuads(gTexture, CELL_SIZE, CELL_SIZE)

  love.graphics.setFont(gFont)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "space" or key == "up" then
    if state == "playing" then
      tetromino:rotate(grid)
    end
  end

  if key == "right" or key == "down" or key == "left" then
    if state == "playing" then
      tetromino:move(key, grid)
    end
  end

  if key == "return" then
    if state == "gameover" then
      time = 0
      grid:reset()
      tetromino = Tetromino:new()

      gamedata:reset()
      state = "playing"
    end
  end
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.update(dt)
  if state == "playing" then
    time = time + dt

    if time > interval then
      time = time % interval

      if tetromino:collides(grid) then
        grid:fill(tetromino)
        local clearedLines = grid:getClearedLines()
        local lines = #clearedLines
        if lines > 0 then
          grid:updateClearedLines(clearedLines)

          local level = gamedata.level
          gamedata.lines = gamedata.lines + lines
          gamedata.score = gamedata.score + level * SCORE_PER_LINES[math.min(lines, #SCORE_PER_LINES)]
          gamedata.level = math.floor(gamedata.lines / 10) + 1
        end

        local frame = gamedata.tetromino.frame
        local type = gamedata.tetromino.type
        tetromino = Tetromino:new({["frame"] = frame, ["type"] = type})

        gamedata:setNewTetromino()

        if tetromino:overlaps(grid) then
          grid:fillGameoverLines()
          tetromino:hide()
          state = "gameover"
        else
        end
      else
        tetromino:update()
      end
    end
  end
end

function love.draw()
  push:start()

  love.graphics.setColor(gColors[1].r, gColors[1].g, gColors[1].b)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.translate((WHITESPACE_COLUMNS + BORDER_COLUMNS) * CELL_SIZE, 0)

  grid:render()
  tetromino:render()

  love.graphics.translate((GRID_COLUMNS + BORDER_COLUMNS + WHITESPACE_COLUMNS) * CELL_SIZE, 0)
  gamedata:render()

  push:finish()
end
