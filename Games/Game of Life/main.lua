require "src/Dependencies"

function love.load()
  love.window.setTitle("Game of Life")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
  love.window.setMode(0, 0)

  -- math.randomseed(os.time())
  WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

  font = love.graphics.newFont("res/font.ttf", math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 40))
  love.graphics.setFont(font)

  local gridWidth = math.floor(WINDOW_WIDTH / 1.5)
  local gridHeight = math.floor(WINDOW_HEIGHT / 1.5)

  if gridWidth > gridHeight then
    gridWidth = gridHeight * COLUMNS / ROWS
  else
    gridHeight = gridWidth * ROWS / COLUMNS
  end

  local offset = {
    ["x"] = WINDOW_WIDTH / 2 - gridWidth,
    ["y"] = WINDOW_HEIGHT / 2 - gridHeight / 2
  }

  if WINDOW_HEIGHT > WINDOW_WIDTH then
    offset.x = WINDOW_WIDTH / 2 - gridWidth / 2
    offset.y = WINDOW_HEIGHT / 2 - gridHeight
  end

  grid = Grid:new(COLUMNS, ROWS, gridWidth, gridHeight, offset)

  isAnimating = false
  timer = 0

  -- actions = {
  --   {
  --     ["text"] = "Step",
  --     ["callback"] = function()
  --       step()
  --     end
  --   },
  --   {
  --     ["text"] = "Animate",
  --     ["callback"] = function()
  --       isAnimating = true
  --     end
  --   },
  --   {
  --     ["text"] = "Reset",
  --     ["callback"] = function()
  --       grid = buildGrid()
  --       generation = 0
  --     end
  --   }
  -- }

  -- buttons = {}
  -- buttonWidth = 0
  -- for i, action in ipairs(actions) do
  --   local width = font:getWidth(action.text) * 1.25
  --   if width > buttonWidth then
  --     buttonWidth = width
  --   end
  -- end

  -- buttonHeight = font:getHeight() * 2
  -- for i, action in ipairs(actions) do
  --   local button =
  --     Button:new(8, 8 + (buttonHeight * 2) * (i - 1), buttonWidth, buttonHeight, action.text, action.callback)
  --   table.insert(buttons, button)
  -- end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    grid:step()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "s" then
    grid:step()
  elseif key == "space" then
    isAnimating = isAnimating and false or true
  end
end

function love.update(dt)
  if isAnimating then
    timer = timer + dt
    if timer >= INTERVAL then
      timer = timer % INTERVAL
      grid:step()
    end
  end
end

function love.draw()
  grid:render()

  -- love.graphics.printf("Generation " .. generation, 0, gridHeight + 16, gridWidth, "center")
  -- for i, button in ipairs(buttons) do
  --   button:render()
  -- end
end
