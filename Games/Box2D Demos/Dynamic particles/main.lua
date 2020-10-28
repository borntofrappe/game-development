WINDOW_WIDTH = 600
WINDOW_HEIGHT = 500
RADIUS = 10

function love.load()
  love.window.setTitle("Dynamic particles")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setBackgroundColor(0.1, 0.1, 0.2)

  circles = {}
end

function love.mousepressed(x, y, button)
  table.insert(
    circles,
    {
      ["cx"] = x,
      ["cy"] = y,
      ["r"] = RADIUS
    }
  )
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    circles = {}
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    table.insert(
      circles,
      {
        ["cx"] = x,
        ["cy"] = y,
        ["r"] = RADIUS
      }
    )
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  for i, circle in ipairs(circles) do
    love.graphics.circle("fill", circle.cx, circle.cy, circle.r)
  end
end
