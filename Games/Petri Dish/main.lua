require "src/Dependencies"

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Petri Dish")
  love.graphics.setBackgroundColor(0.82, 0.9, 0.98)

  player = Particle:new(0, 0, PLAYER_RADIUS)
  particles = {}

  -- add particles in the visible window
  for i = 1, PARTICLES do
    local r = love.math.random(PARTICLE_RADIUS_MIN, PARTICLE_RADIUS_MAX)
    local x = love.math.random(-WINDOW_WIDTH, WINDOW_WIDTH)
    local y = love.math.random(-WINDOW_HEIGHT, WINDOW_HEIGHT)
    table.insert(particles, Particle:new(x, y, r))
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

  -- following a key being pressed continuously update the coordinates
  if
    love.keyboard.isDown("up") or love.keyboard.isDown("right") or love.keyboard.isDown("down") or
      love.keyboard.isDown("left")
   then
    local speed = {
      ["x"] = 0,
      ["y"] = 0
    }

    if love.keyboard.isDown("up") then
      speed.y = -PLAYER_SPEED
    end
    if love.keyboard.isDown("right") then
      speed.x = PLAYER_SPEED
    end
    if love.keyboard.isDown("down") then
      speed.y = PLAYER_SPEED
    end
    if love.keyboard.isDown("left") then
      speed.x = -PLAYER_SPEED
    end

    player.x = player.x + speed.x * dt
    player.y = player.y + speed.y * dt
    translate.x = -player.x - speed.x * dt
    translate.y = -player.y - speed.y * dt
  end

  -- following the mouse being pressed update the coordinates with a timer
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    x = x - WINDOW_WIDTH / 2
    y = y - WINDOW_HEIGHT / 2
    Timer:after(
      0.01,
      function()
        -- remove previous tween animations
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

  -- player and particle update the modify the offset
  player:update(dt)

  for i, particle in ipairs(particles) do
    particle:update(dt)
    if player:collides(particle) then
      player:assimilates(particle)
      table.remove(particles, i)
      addParticle()
    end

    -- remove the particles (and replace each copy with a new one) when exceeding an arbitrary threshold
    -- ! * player / PLAYER_RADIUS to consider the scale applied to the window
    if
      particle.x < player.x - (math.max(WINDOW_WIDTH, WINDOW_HEIGHT) * 2 * player.r / PLAYER_RADIUS) or
        particle.x > player.x + (math.max(WINDOW_WIDTH, WINDOW_HEIGHT) * 2 * player.r / PLAYER_RADIUS) or
        particle.y < player.y - (math.max(WINDOW_WIDTH, WINDOW_HEIGHT) * 2 * player.r / PLAYER_RADIUS) or
        particle.y > player.y + (math.max(WINDOW_WIDTH, WINDOW_HEIGHT) * 2 * player.r / PLAYER_RADIUS)
     then
      table.remove(particles, i)
      addParticle()
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
end

function addParticle()
  -- add a particle just outside of the visible area
  local angle = love.math.random() * math.pi * 2
  local distance = math.max(WINDOW_WIDTH, WINDOW_HEIGHT) * player.r / PLAYER_RADIUS

  local x = math.floor(player.x + math.cos(angle) * distance)
  local y = math.floor(player.y + math.sin(angle) * distance)

  local r = math.floor(love.math.random(PARTICLE_RADIUS_MIN, PARTICLE_RADIUS_MAX) * player.r / PLAYER_RADIUS)
  table.insert(particles, Particle:new(x, y, r))
end
