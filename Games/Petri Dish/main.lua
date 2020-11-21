require "src/Dependencies"

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Petri Dish")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  translation = {
    ["x"] = 0,
    ["y"] = 0
  }
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
  Timer:update(dt)
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    Timer:after(
      0.1,
      function()
        for i, tween in ipairs(Timer.tweens) do
          if tween.label == "translation" then
            table.remove(Timer.tweens, i)
          end
        end

        Timer:tween(
          0.5,
          {
            [player] = {["x"] = x, ["y"] = y}
          },
          "translation"
        )
      end
    )
  end

  for i, particle in ipairs(particles) do
    if player:collides(particle) then
      table.remove(particles, i)
      player:grow(particle.r)
    end
  end
end

function love.draw()
  player:render()
  for i, particle in ipairs(particles) do
    particle:render()
  end
end
