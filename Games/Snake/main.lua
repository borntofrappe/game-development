require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["title"] = love.graphics.newFont("res/fonts/font-bold.ttf", 64),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 24)
  }

  gStateMachine =
    StateMachine:create(
    {
      ["title"] = function()
        return TitleScreenState:create()
      end,
      ["play"] = function()
        return PlayState:create()
      end
    }
  )

  gStateMachine:change("title")

  love.keyboard.keyPressed = {}

  toggleGrid = true
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true

  if key == "g" or key == "G" then
    toggleGrid = not toggleGrid
  end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  gStateMachine:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(0.035, 0.137, 0.298, 1)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  gStateMachine:render()

  if toggleGrid then
    renderGrid()
  end
end

function renderGrid()
  local columns = math.floor(WINDOW_WIDTH / CELL_SIZE)
  local rows = math.floor(WINDOW_HEIGHT / CELL_SIZE)

  love.graphics.setColor(0.224, 0.824, 0.604)
  for x = 1, columns do
    for y = 1, rows do
      love.graphics.rectangle("line", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end
end
