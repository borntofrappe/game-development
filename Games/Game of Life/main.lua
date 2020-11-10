require "src/Dependencies"

function love.load()
  love.window.setTitle("Game of Life")
  love.graphics.setBackgroundColor(0, 0.05, 0.09)

  love.window.setMode(0, 0)
  WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

  math.randomseed(os.time())
  isAnimating = false
  timer = 0

  -- font
  local fontSize = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 40)
  font = love.graphics.newFont("res/font.ttf", fontSize)
  love.graphics.setFont(font)

  -- grid
  local gridWidth = math.floor(WINDOW_WIDTH / 1.5)
  local gridHeight = math.floor(WINDOW_HEIGHT / 1.5)

  if gridWidth > gridHeight then
    gridWidth = gridHeight * COLUMNS / ROWS
  else
    gridHeight = gridWidth * ROWS / COLUMNS
  end

  local offsetGrid = {
    ["x"] = WINDOW_WIDTH / 2 - gridWidth,
    ["y"] = WINDOW_HEIGHT / 2 - gridHeight / 2
  }

  if WINDOW_HEIGHT > WINDOW_WIDTH then
    offsetGrid.x = WINDOW_WIDTH / 2 - gridWidth / 2
    offsetGrid.y = WINDOW_HEIGHT / 2 - gridHeight
  end

  grid = Grid:new(COLUMNS, ROWS, gridWidth, gridHeight, offsetGrid)

  -- buttons
  local actions = {
    {
      ["text"] = "Step forward",
      ["callback"] = function()
        grid:step()
      end
    },
    {
      ["text"] = "Toggle animation",
      ["callback"] = function()
        isAnimating = not isAnimating
      end
    },
    {
      ["text"] = "Reset simulation",
      ["callback"] = function()
        grid:reset()
      end
    },
    {
      ["text"] = "Add pattern",
      ["callback"] = function()
        grid:addPattern()
      end
    }
  }

  buttons = {}
  local buttonWidth = 0
  local buttonHeight = font:getHeight() * 2.5

  for i, action in ipairs(actions) do
    local width = font:getWidth(action.text) * 1.25
    if width > buttonWidth then
      buttonWidth = width
    end
  end

  local offsetButtons = {
    ["x"] = WINDOW_WIDTH * 3 / 4 - buttonWidth / 2,
    ["y"] = WINDOW_HEIGHT / 2 - (#buttons + 1) * (buttonHeight * 2) - buttonHeight
  }

  if WINDOW_HEIGHT > WINDOW_WIDTH then
    offsetButtons.x = WINDOW_WIDTH / 2 - buttonWidth / 2
    offsetButtons.y = WINDOW_HEIGHT * 3 / 4 - (#buttons + 1) * (buttonHeight * 2) - buttonHeight
  end

  for i, action in ipairs(actions) do
    local button =
      Button:new(
      offsetButtons.x,
      offsetButtons.y + (buttonHeight * 2) * (i - 1),
      buttonWidth,
      buttonHeight,
      action.text,
      action.callback
    )
    table.insert(buttons, button)
  end
end

-- consider if the cursor is pressed on top of the grid or one of the buttons
function love.mousepressed(x, y, button)
  if button == 1 then
    if x > grid.offset.x and x < grid.offset.x + grid.width and y > grid.offset.y and y < grid.offset.y + grid.height then
      local column = math.floor((x - grid.offset.x) / grid.width * grid.columns) + 1
      local row = math.floor((y - grid.offset.y) / grid.height * grid.rows) + 1
      grid:toggleCell(column, row)
    else
      for i, button in ipairs(buttons) do
        if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
          button.callback()
          break
        end
      end
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "s" then
    grid:step()
  elseif key == "t" then
    isAnimating = not isAnimating
  elseif key == "r" then
    grid:reset()
  elseif key == "a" then
    grid:addPattern()
  end
end

function love.update(dt)
  -- consider whether the cursor hvoers above a button
  local x, y = love.mouse:getPosition()
  if x and y then
    for i, button in ipairs(buttons) do
      if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
        button:highlight()
      else
        button:reset()
      end
    end
  end

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

  for i, button in ipairs(buttons) do
    button:render()
  end
end
