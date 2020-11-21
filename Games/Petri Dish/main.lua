require "src/Dependencies"

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Petri Dish")
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  player = Player:new()
  particles = {}
  for i = 0, PARTICLES do
    local x = love.math.random(-WINDOW_WIDTH, WINDOW_WIDTH)
    local y = love.math.random(-WINDOW_HEIGHT, WINDOW_HEIGHT)
    table.insert(particles, Particle:new(x, y, PARTICLE_RADIUS))
  end

  translate = {
    ["x"] = WINDOW_WIDTH / 2,
    ["y"] = WINDOW_HEIGHT / 2
  }
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
    x = x - WINDOW_WIDTH / 2
    y = y - WINDOW_HEIGHT / 2
    Timer:after(
      0.01,
      function()
        for i, tween in ipairs(Timer.tweens) do
          if tween.label == "translate" then
            table.remove(Timer.tweens, i)
          end
        end

        Timer:tween(
          0.15,
          {
            [player] = {["x"] = player.x + x, ["y"] = player.y + y},
            [translate] = {["x"] = WINDOW_WIDTH / 2 - player.x - x, ["y"] = WINDOW_HEIGHT / 2 - player.y - y}
          },
          "translate"
        )
      end
    )
  end

  for i, particle in ipairs(particles) do
    if player:collides(particle) then
      table.remove(particles, i)
      player:assimilate(particle)
    end
  end
end

function love.draw()
  love.graphics.translate(translate.x, translate.y)
  for i, particle in ipairs(particles) do
    particle:render()
  end
  player:render()
end
