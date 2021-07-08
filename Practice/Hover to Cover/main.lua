require "src/Dependencies"

local spaceship = Spaceship:new()
local debris = {Debris:new()}
local collision

local INTERVAL = 2
local COUNTDOWN = 2
local timer = 0

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

  if collision then
    if timer >= COUNTDOWN then
      timer = timer % COUNTDOWN
      collision = nil
      spaceship = Spaceship:new()
      debris = {Debris:new()}
    end
  else
    if timer >= INTERVAL then
      timer = timer % INTERVAL
      table.insert(debris, Debris:new())
    end
  end

  for k, deb in pairs(debris) do
    deb:update(dt)

    if spaceship and spaceship:collides(deb) then
      collision = Collision:new(spaceship.x + spaceship.width / 2, spaceship.y + spaceship.height / 2)
      spaceship = nil
      timer = 0
      break
    end
  end

  if not collision then
    spaceship:update(dt)

    if love.keyboard.isDown("up") then
      spaceship:thrust()
    end
  end
end

function love.draw()
  push:start()

  for k, deb in pairs(debris) do
    deb:render()
  end

  if collision then
    collision:render()
  else
    spaceship:render()
  end

  push:finish()
end
