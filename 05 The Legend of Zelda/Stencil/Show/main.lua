-- good luck

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400
SPOTLIGHT_SPEED = 200
STAR_SPEED_MIN = 100
STAR_SPEED_MAX = 200
STARS = 70
STAR_RADIUS_MAX = 4

function love.load()
  love.window.setTitle("Stencil — Show")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.13, 0.1, 0.23)

  spotlight = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2,
    ["r"] = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 4)
  }

  stars = {}
  for i = 1, STARS do
    local x, y
    local r = love.math.random(STAR_RADIUS_MAX)
    local speed = love.math.random(STAR_SPEED_MIN, STAR_SPEED_MAX)
    if love.math.random(2) == 1 then
      x = love.math.random(0, WINDOW_WIDTH)
      y = 0
    else
      x = 0
      y = love.math.random(0, WINDOW_HEIGHT)
    end
    local star = {
      ["x"] = x,
      ["y"] = y,
      ["r"] = r,
      ["speed"] = speed
    }
    table.insert(stars, star)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    spotlight.y = math.max(0, spotlight.y - SPOTLIGHT_SPEED * dt)
  end
  if love.keyboard.isDown("right") then
    spotlight.x = math.min(WINDOW_WIDTH, spotlight.x + SPOTLIGHT_SPEED * dt)
  end
  if love.keyboard.isDown("down") then
    spotlight.y = math.min(WINDOW_HEIGHT, spotlight.y + SPOTLIGHT_SPEED * dt)
  end
  if love.keyboard.isDown("left") then
    spotlight.x = math.max(0, spotlight.x - SPOTLIGHT_SPEED * dt)
  end

  for i, star in ipairs(stars) do
    star.x = star.x + dt * star.speed
    star.y = star.y + dt * star.speed

    if star.x >= WINDOW_WIDTH or star.y >= WINDOW_HEIGHT then
      star.r = love.math.random(STAR_RADIUS_MAX)
      star.speed = love.math.random(STAR_SPEED_MIN, STAR_SPEED_MAX)
      if love.math.random(2) == 1 then
        star.x = love.math.random(0, WINDOW_WIDTH)
        star.y = 0
      else
        star.x = 0
        star.y = love.math.random(0, WINDOW_HEIGHT)
      end
    end
  end

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    spotlight.x = x
    spotlight.y = y
  end
end

local function stencilFunction()
  love.graphics.circle("fill", spotlight.x, spotlight.y, spotlight.r)
end

function love.draw()
  love.graphics.setColor(0.9, 0.68, 0.34)
  love.graphics.circle("fill", spotlight.x, spotlight.y, spotlight.r)

  love.graphics.stencil(stencilFunction, "replace", 1)
  love.graphics.setStencilTest("greater", 0)

  love.graphics.setColor(1, 1, 1, 1)
  for i, star in ipairs(stars) do
    love.graphics.circle("fill", star.x, star.y, star.r)
  end

  love.graphics.setStencilTest()
end
