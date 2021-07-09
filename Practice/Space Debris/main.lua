require "src/Dependencies"

local spaceship = Spaceship:new()
local debris = {Debris:new()}
local collision = Collision:new()

local state = "playing"
local timer = 0
local INTERVAL = 1.5
local DELAY = 3

local sounds = {
  ["collision"] = love.audio.newSource("res/sounds/collision.wav", "static"),
  ["thrust"] = love.audio.newSource("res/sounds/thrust.wav", "static")
}

function love.load()
  love.window.setTitle("Space Debris")
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

      sounds["thrust"]:stop()
      sounds["thrust"]:play()
    end

    if timer >= INTERVAL then
      timer = timer % INTERVAL
      table.insert(debris, Debris:new(debris[#debris]))
    end
  elseif state == "gameover" then
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
      local x, y, dx, dy = spaceship:collides(deb)
      if x then
        state = "gameover"
        collision:emit(x, y, dx, dy, dx * 3, dy * 3)

        timer = 0

        sounds["thrust"]:stop()
        sounds["collision"]:play()
      end
    end

    if deb.x < -deb.width or deb.x > VIRTUAL_WIDTH then
      table.remove(debris, k)
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
  elseif state == "gameover" then
    collision:render()
  end

  push:finish()
end
