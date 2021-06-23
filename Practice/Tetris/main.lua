require "src/Dependencies"

function love.load()
  love.window.setTitle("Tetris")
  -- math.randomseed(os.time()) -- TODO uncomment this line

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

  grid = Grid:new(COLUMNS, ROWS)
  tetromino = Tetromino:new(grid)
  -- info = Info:new() -- TODO implement info feature

  interval = 1
  time = 0
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  -- TODO implement rotate feature
  -- if key == 'space' or key == 'up' then
  --   tetromino:rotate()
  -- end

  if key == "right" or key == "down" or key == "left" then
    tetromino:move(key, grid)
  end
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.update(dt)
  time = time + dt
  if time > interval then
    time = time % interval
    if tetromino:collides(grid) then
      grid:fill(tetromino)
      tetromino = Tetromino:new(grid)
    else
      tetromino:update()
    end
  end
end

function love.draw()
  push:start()

  love.graphics.setColor(gColors[1].r, gColors[1].g, gColors[1].b)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  -- info:render() -- TODO implement info feature

  love.graphics.translate((LEFT_PADDING_COLUMNS + BORDER_COLUMNS) * CELL_SIZE, 0)
  grid:render()
  tetromino:render()

  push:finish()
end
