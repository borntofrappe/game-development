require "src/Dependencies"

local spaceship = Spaceship:new()
local debris = {Debris:new()}

local INTERVAL = 2
local DELAY = 2
local timer = 0
local collision = Collision:new()

local state = "playing"

function love.load()
  love.window.setTitle("Hover to Cover")
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(
    VIRTUAL_WIDTH,
    VIRTUAL_HEIGHT,
    WINDOW_WIDTH,
    WINDOW_HEIGHT,
    {
      fullscreen = false,
      resizable = true,
      vsync = true
    }
  )

  love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
end

function love.resize(width, height)
  push:resize(width, height)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  timer = timer + dt

  if state == "playing" then
    spaceship:update(dt)

    if love.keyboard.isDown("up") then
      spaceship:thrust()
    end

    if timer >= INTERVAL then
      timer = timer % INTERVAL
      table.insert(debris, Debris:new())
    end
  else
    collision:update(dt)

    if timer >= DELAY then
      timer = timer % DELAY
      spaceship = Spaceship:new()
      state = "playing"
    end
  end

  for k, deb in pairs(debris) do
    deb:update(dt)

    if state == "playing" then
      local x, y, gapX, gapY = spaceship:collides(deb)
      if x then
        state = "gameover"
        collision:emit(x, y, gapX, gapY)
        timer = 0
      end
    end
  end
end

function love.draw()
  push:start()

  for k, deb in pairs(debris) do
    deb:render()
  end

  if state == "playing" then
    spaceship:render()
  else
    collision:render()
  end

  push:finish()
end
