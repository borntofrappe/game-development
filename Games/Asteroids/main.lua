require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Asteroids")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

  colors = {
    ["background"] = {["r"] = 1, ["g"] = 1, ["b"] = 1},
    ["foreground"] = {["r"] = 0, ["g"] = 0, ["b"] = 0}
  }

  font = love.graphics.newFont("res/fonts/font.ttf", 18)
  love.graphics.setFont(font)
  points = {
    [3] = 20,
    [2] = 50,
    [1] = 100
  }

  love.keyboard.keyPressed = {}

  score = 0
  hiScore = 3500
  lives = 3

  player = Player:create()
  projectiles = {}
  asteroids = {}

  for i = 1, 4 do
    table.insert(asteroids, Asteroid:create())
  end
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

  for k, asteroid in pairs(asteroids) do
    asteroid:update(dt)
    if testAABB(player, asteroid) then
      lives = math.max(0, lives - 1)
      player:reset()
      asteroid.inPlay = false
    end

    if not asteroid.inPlay then
      if asteroid.size > 1 then
        table.insert(asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
        table.insert(asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
      end
      score = score + points[asteroid.size]
      if score > hiScore then
        hiScore = score
      end
      table.remove(asteroids, k)
    end
  end

  for k, projectile in pairs(projectiles) do
    projectile:update(dt)
    for j, asteroid in pairs(asteroids) do
      if testAABB(projectile, asteroid) then
        projectile.inPlay = false
        asteroid.inPlay = false
      end
    end
    if not projectile.inPlay then
      table.remove(projectiles, k)
    end
  end
  player:update(dt)

  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(colors["background"]["r"], colors["background"]["g"], colors["background"]["b"])
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  showGameStats(score, hiScore, lives)

  for k, asteroid in pairs(asteroids) do
    asteroid:render()
  end

  for k, projectile in pairs(projectiles) do
    projectile:render()
  end
  player:render()
end

function testAABB(circle1, circle2)
  if circle1.x > circle2.x + circle2.r or circle1.x < circle2.x - circle2.r then
    return false
  end

  if circle1.y > circle2.y + circle2.r or circle1.y < circle2.y - circle2.r then
    return false
  end

  return true
end

function showGameStats(score, hiScore, lives)
  love.graphics.setColor(colors["foreground"]["r"], colors["foreground"]["g"], colors["foreground"]["b"])
  local x = math.floor(WINDOW_WIDTH / 4)
  local y = 2
  love.graphics.print(hiScore, x, y)

  y = y + 20
  love.graphics.printf(score, 0, y, x, "right")
  x = x + 4
  for life = 1, lives - 1 do
    x = x + 8
    love.graphics.polygon("fill", x, y + 2, x, y + 15, x - 6, y + 10)
  end
end
