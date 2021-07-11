require "Cell"

WINDOW_WIDTH = 520
WINDOW_HEIGHT = 380

local CANVAS_WIDTH = math.floor(WINDOW_WIDTH / 2)
local CANVAS_HEIGHT = WINDOW_HEIGHT

local cell
local canvases

local TRANSLATION_SPEED = 200

local translations = {
  {["x"] = 0, ["y"] = 0},
  {["x"] = -CANVAS_WIDTH, ["y"] = 0}
}

function getCanvases(cell, translations)
  local canvases = {}

  for i, translation in ipairs(translations) do
    local canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
    love.graphics.setCanvas(canvas)

    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.printf(
      "Translation\n(" .. translation.x .. ", " .. translation.y .. ")",
      0,
      8,
      CANVAS_WIDTH,
      "center"
    )

    love.graphics.push()

    love.graphics.translate(translation.x, translation.y)
    cell:render()

    love.graphics.pop()

    love.graphics.setCanvas()

    table.insert(canvases, canvas)
  end

  return canvases
end

function love.load()
  love.window.setTitle("Canvas Dynamic")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.94, 0.94)

  cell = Cell:new()
  canvases = getCanvases(cell, translations)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    cell = Cell:new()
    canvases = getCanvases(cell, translations)
  end

  if key == "c" then
    cell:setRandomColor()
    canvases = getCanvases(cell, translations)
  end
end

function love.update(dt)
  if
    love.keyboard.isDown("up") or love.keyboard.isDown("right") or love.keyboard.isDown("down") or
      love.keyboard.isDown("left") or
      love.keyboard.isDown("w") or
      love.keyboard.isDown("d") or
      love.keyboard.isDown("s") or
      love.keyboard.isDown("a")
   then
    if love.keyboard.isDown("w") then
      translations[1].y = math.floor(translations[1].y + dt * TRANSLATION_SPEED)
    elseif love.keyboard.isDown("d") then
      translations[1].x = math.floor(translations[1].x - dt * TRANSLATION_SPEED)
    elseif love.keyboard.isDown("s") then
      translations[1].y = math.floor(translations[1].y - dt * TRANSLATION_SPEED)
    elseif love.keyboard.isDown("a") then
      translations[1].x = math.floor(translations[1].x + dt * TRANSLATION_SPEED)
    end

    if love.keyboard.isDown("up") then
      translations[2].y = math.floor(translations[2].y + dt * TRANSLATION_SPEED)
    elseif love.keyboard.isDown("right") then
      translations[2].x = math.floor(translations[2].x - dt * TRANSLATION_SPEED)
    elseif love.keyboard.isDown("down") then
      translations[2].y = math.floor(translations[2].y - dt * TRANSLATION_SPEED)
    elseif love.keyboard.isDown("left") then
      translations[2].x = math.floor(translations[2].x + dt * TRANSLATION_SPEED)
    end

    canvases = getCanvases(cell, translations)
  end
end

function love.draw()
  love.graphics.setColor(0.1, 0.1, 0.1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.line(WINDOW_WIDTH / 2, 0, WINDOW_WIDTH / 2, WINDOW_HEIGHT)

  love.graphics.printf("(0, 0)", 0, 0, WINDOW_WIDTH, "left")
  love.graphics.printf("(" .. WINDOW_WIDTH .. ", 0)", 0, 0, WINDOW_WIDTH, "right")
  love.graphics.printf("(0, " .. WINDOW_HEIGHT .. ")", 0, WINDOW_HEIGHT - 14, WINDOW_WIDTH, "left")
  love.graphics.printf(
    "(" .. WINDOW_WIDTH .. ", " .. WINDOW_HEIGHT .. ")",
    0,
    WINDOW_HEIGHT - 14,
    WINDOW_WIDTH,
    "right"
  )

  love.graphics.setColor(1, 1, 1, 1)
  for i, canvas in ipairs(canvases) do
    love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
  end
end
