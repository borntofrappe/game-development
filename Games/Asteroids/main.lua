require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  love.keyboard.keyPressed = {}

  player = Player:create()
  projectiles = {}
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("space") then
    local projectile = Projectile:create(player.x, player.y, player.angle)
    table.insert(projectiles, projectile)
  end

  for k, projectile in pairs(projectiles) do
    projectile:update(dt)
    if not projectile.inPlay then
      table.remove(projectiles, k)
    end
  end
  player:update(dt)

  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  for k, projectile in pairs(projectiles) do
    projectile:render()
  end
  player:render()
end
