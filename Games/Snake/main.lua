require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  gFonts = {
    ["large"] = love.graphics.newFont("res/font.ttf", 64),
    ["normal"] = love.graphics.newFont("res/font.ttf", 24)
  }

  gColors = {
    ["background"] = {
      ["r"] = 0,
      ["g"] = 0.14,
      ["b"] = 0.3
    },
    ["foreground"] = {
      ["r"] = 0.22,
      ["g"] = 0.82,
      ["b"] = 0.6
    },
    ["snake"] = {
      ["r"] = 0.5,
      ["g"] = 0.9,
      ["b"] = 0.75
    }
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

  toggleGrid = false
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
  love.graphics.setColor(gColors["background"].r, gColors["background"].g, gColors["background"].b)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  gStateMachine:render()

  if toggleGrid then
    renderGrid()
  end
end

function renderGrid()
  local columns = math.floor(WINDOW_WIDTH / CELL_SIZE)
  local rows = math.floor(WINDOW_HEIGHT / CELL_SIZE)

  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  for x = 1, columns do
    for y = 1, rows do
      love.graphics.rectangle("line", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end
end
