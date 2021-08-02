require "src/Dependencies"

function love.load()
  gColors = {
    ["background"] = {
      ["r"] = 0.14,
      ["g"] = 0.14,
      ["b"] = 0.14
    },
    ["ui"] = {
      ["r"] = 1,
      ["g"] = 1,
      ["b"] = 1
    },
    ["balls"] = {
      {["r"] = 1, ["g"] = 0.35, ["b"] = 0.26},
      {["r"] = 0.93, ["g"] = 0.4, ["b"] = 0.98},
      {["r"] = 1, ["g"] = 0.67, ["b"] = 0.3},
      {["r"] = 0.59, ["g"] = 0.89, ["b"] = 0.37},
      {["r"] = 0.42, ["g"] = 0.54, ["b"] = 0.91},
      {["r"] = 1, ["g"] = 0.98, ["b"] = 0.3},
      {["r"] = 0.96, ["g"] = 0.71, ["b"] = 0.91},
      {["r"] = 1, ["g"] = 1, ["b"] = 1}
    }
  }

  gFonts = {
    ["large"] = love.graphics.newFont("res/font.ttf", 64),
    ["normal"] = love.graphics.newFont("res/font.ttf", 22)
  }

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end,
      ["points"] = function()
        return PointsState:new()
      end
    }
  )

  math.randomseed(os.time())
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(gColors.background.r, gColors.background.g, gColors.background.b)

  gStateMachine:change("start")

  love.mouse.buttonpressed = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  love.mouse.buttonpressed[button] = true
end

function love.mouse.waspressed(button)
  return love.mouse.buttonpressed[button]
end

function love.update(dt)
  gStateMachine:update(dt)

  love.mouse.buttonpressed = {}
end

function love.draw()
  love.graphics.translate(TABLE_MARGIN, TABLE_MARGIN)
  love.graphics.setColor(gColors.ui.r, gColors.ui.g, gColors.ui.b)
  love.graphics.setLineWidth(TABLE_LINE_WIDTH)
  love.graphics.rectangle("line", 0, 0, TABLE_WIDTH, TABLE_HEIGHT, 24)

  love.graphics.translate(TABLE_PADDING, TABLE_PADDING)
  love.graphics.rectangle("line", 0, 0, TABLE_INNER_WIDTH, TABLE_INNER_HEIGHT, 16)

  for _, pocketCoords in ipairs(POCKET_COORDS) do
    love.graphics.circle("line", pocketCoords[1], pocketCoords[2], POCKET_RADIUS)
  end

  love.graphics.setColor(gColors.background.r, gColors.background.g, gColors.background.b)
  love.graphics.setLineWidth(TABLE_PADDING - TABLE_LINE_WIDTH)
  love.graphics.rectangle(
    "line",
    -TABLE_PADDING / 2,
    -TABLE_PADDING / 2,
    TABLE_INNER_WIDTH + TABLE_PADDING,
    TABLE_INNER_HEIGHT + TABLE_PADDING,
    20
  )

  love.graphics.setColor(gColors.background.r, gColors.background.g, gColors.background.b)
  for _, pocketCoords in ipairs(POCKET_COORDS) do
    love.graphics.circle("fill", pocketCoords[1], pocketCoords[2], POCKET_INNER_RADIUS)
  end

  gStateMachine:render()
end
