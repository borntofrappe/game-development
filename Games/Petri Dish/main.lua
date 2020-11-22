require "src/Dependencies"

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Petri Dish")
  love.graphics.setBackgroundColor(0.99, 0.99, 1)

  player = Player:new()
  particles = {}
  for i = 0, PARTICLES do
    local x = love.math.random(math.floor(-WINDOW_WIDTH / 2), math.floor(WINDOW_WIDTH / 2))
    local y = love.math.random(math.floor(-WINDOW_HEIGHT / 2), math.floor(WINDOW_HEIGHT / 2))
    table.insert(particles, Particle:new(x, y, player.r / PARTICLE_RADIUS_FRACTION))
  end

  translate = {
    ["x"] = 0,
    ["y"] = 0
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
            [translate] = {["x"] = -player.x - x, ["y"] = -player.y - y}
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

      local x = (love.math.random() - 0.5) * WINDOW_WIDTH * player.r / PLAYER_RADIUS
      local y = (love.math.random() - 0.5) * WINDOW_HEIGHT * player.r / PLAYER_RADIUS
      table.insert(particles, Particle:new(x, y, player.r / PARTICLE_RADIUS_FRACTION))
    end
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  love.graphics.scale(PLAYER_RADIUS / player.r)
  love.graphics.translate(translate.x, translate.y)
  for i, particle in ipairs(particles) do
    particle:render()
  end
  player:render()
  love.graphics.setColor(0, 0, 0, 0.2)
  love.graphics.circle("fill", player.x, player.y, WINDOW_HEIGHT * player.r / PLAYER_RADIUS)
  love.graphics.setColor(1, 1, 1, 0.2)
  love.graphics.circle("fill", player.x, player.y, WINDOW_HEIGHT / 2 * player.r / PLAYER_RADIUS)
end
