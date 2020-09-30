require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Snake")
  love.window.setMode(WINDOW_WIDTH + PADDING * 2 + MARGIN * 2, WINDOW_HEIGHT + PADDING * 2 + MARGIN * 2, OPTIONS)

  gStateMachine =
    StateMachine:create(
    {
      ["start"] = function()
        return StartState:create()
      end,
      ["play"] = function()
        return PlayState:create()
      end,
      ["gameover"] = function()
        return GameoverState:create()
      end
    }
  )

  gStateMachine:change("start")

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
  love.graphics.rectangle(
    "fill",
    0,
    0,
    WINDOW_WIDTH + PADDING * 2 + MARGIN * 2,
    WINDOW_HEIGHT + PADDING * 2 + MARGIN * 2
  )

  love.graphics.translate(MARGIN, MARGIN)
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  love.graphics.rectangle("line", 0, 0, WINDOW_WIDTH + PADDING * 2, WINDOW_HEIGHT + PADDING * 2)

  love.graphics.translate(PADDING, PADDING)
  gStateMachine:render()

  if toggleGrid then
    renderGrid()
  end
end

function renderGrid()
  love.graphics.setColor(gColors["foreground"].r, gColors["foreground"].g, gColors["foreground"].b)
  for x = 1, COLUMNS do
    for y = 1, ROWS do
      love.graphics.rectangle("line", (x - 1) * CELL_SIZE, (y - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
    end
  end
end

function testAABB(box1, box2)
  return box1.column == box2.column and box1.row == box2.row
end
