require "src/Dependencies"

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Petri Dish")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  player = Player:new()
  particles = {}
  for i = 0, PARTICLES do
    local x = love.math.random(WINDOW_WIDTH)
    local y = love.math.random(WINDOW_HEIGHT)
    table.insert(particles, Particle:new(x, y, PARTICLE_RADIUS))
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
end

function love.draw()
  for i, particle in ipairs(particles) do
    particle:render()
  end
  player:render()
end
