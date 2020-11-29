WINDOW_WIDTH = 520
WINDOW_HEIGHT = 380
CANVAS_WIDTH = math.floor(WINDOW_WIDTH / 2)
CANVAS_HEIGHT = 380
CELL_SIZE = 20
TRANSLATION_SPEED = 200

function love.load()
  love.window.setTitle("Dynamic Canvas")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  rectangle = {
    ["x"] = 0,
    ["y"] = 0
  }
  translations = {
    {["x"] = 0, ["y"] = 0},
    {["x"] = 0, ["y"] = 0}
  }

  canvases = getCanvases(translations)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "r" then
    rectangle.x = rectangle.x + love.math.random(-20, 20)
    rectangle.y = rectangle.y + love.math.random(-20, 20)
    canvases = getCanvases(translations)
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

    canvases = getCanvases(translations)
  end
end

function love.draw()
  for i, canvas in ipairs(canvases) do
    love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
  end
  love.graphics.line(CANVAS_WIDTH, 0, CANVAS_WIDTH, CANVAS_HEIGHT)
end

function getCanvases(translations)
  local canvases = {}
  for i, translate in ipairs(translations) do
    canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.push()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("(" .. translations[i].x .. ", " .. translations[i].y .. ")", 0, 0, CANVAS_WIDTH, "right")

    love.graphics.translate(translate.x, translate.y)
    love.graphics.print(
      "(" .. rectangle.x .. ", " .. rectangle.y .. ")",
      rectangle.x + CELL_SIZE,
      rectangle.y + CELL_SIZE / 2
    )
    love.graphics.rectangle("fill", rectangle.x, rectangle.y, CELL_SIZE, CELL_SIZE)
    love.graphics.pop()

    love.graphics.setCanvas()
    canvases[i] = canvas
  end

  return canvases
end
