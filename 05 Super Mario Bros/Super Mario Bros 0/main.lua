require "src/Dependencies"

function love.load()
  love.window.setTitle("Super Mario Bros")
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gStateMachine =
    StateMachine(
    {
      ["play"] = function()
        return PlayState()
      end
    }
  )

  gStateMachine:change("play")
  love.keyboard.keypressed = {}
end

function love.keypressed(key)
  love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
  return love.keyboard.keypressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.keyboard.keypressed = {}
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.draw()
  push:start()

  gStateMachine:render()

  push:finish()
end

function GenerateLevel(width, height)
  local tiles = {}
  for x = 1, width do
    tiles[x] = {}

    local rows_sky = ROWS_SKY

    local isChasm = math.random(5) == 1
    if isChasm then
      rows_sky = height
    else
      local isPillar = math.random(5) == 1
      if isPillar then
        rows_sky = rows_sky - 2
      end
    end

    for y = 1, height do
      local tile = {
        id = y < rows_sky and TILE_SKY or TILE_GROUND,
        topper = y == rows_sky
      }
      tiles[x][y] = tile
    end
  end

  return tiles
end
