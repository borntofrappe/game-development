local WINDOW_WIDTH = 528
local WINDOW_HEIGHT = 384
local WINDOW_PADDING = 20

local TILE_SIZE = 16
local COLUMNS = math.floor(WINDOW_WIDTH / TILE_SIZE)
local ROWS = math.floor(WINDOW_HEIGHT / TILE_SIZE)

function GenerateQuads(atlas)
  local quads = {}
  for i = 1, math.floor(atlas:getWidth() / TILE_SIZE) do
    quads[i] = love.graphics.newQuad((i - 1) * TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, atlas:getDimensions())
  end
  return quads
end

function love.load()
  love.window.setTitle("Sprite Batch")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.392, 0.322, 0.255)

  gTexture = love.graphics.newImage("spritesheet.png")
  gQuads = GenerateQuads(gTexture)

  gSpriteBatch = love.graphics.newSpriteBatch(gTexture)
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      gSpriteBatch:add(gQuads[love.math.random(#gQuads)], (column - 1) * TILE_SIZE, (row - 1) * TILE_SIZE)
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gSpriteBatch)

  love.graphics.setColor(0.392, 0.322, 0.255)
  love.graphics.rectangle(
    "line",
    WINDOW_PADDING,
    WINDOW_PADDING,
    WINDOW_WIDTH - WINDOW_PADDING * 2,
    WINDOW_HEIGHT - WINDOW_PADDING * 2
  )

  love.graphics.circle("fill", WINDOW_PADDING, WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_WIDTH - WINDOW_PADDING, WINDOW_HEIGHT - WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_PADDING, WINDOW_HEIGHT - WINDOW_PADDING, 10)
  love.graphics.circle("fill", WINDOW_WIDTH - WINDOW_PADDING, WINDOW_PADDING, 10)
  love.graphics.printf("Sprite Batch", 0, WINDOW_HEIGHT / 2 - 8, WINDOW_WIDTH, "center")
end
