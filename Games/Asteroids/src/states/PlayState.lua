PlayState = BaseState:create()

function PlayState:enter(params)
  self.difficulty = params.difficulty

  self.points = {
    [3] = 20,
    [2] = 50,
    [1] = 100
  }

  self.score = 0
  self.hiScore = 3500
  self.lives = 3

  self.player = Player:create()
  self.projectiles = {}
  self.asteroids = {}

  for i = 1, self.difficulty * 2 do
    table.insert(self.asteroids, Asteroid:create())
  end
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("space") then
    local projectile = Projectile:create(self.player.x, self.player.y, self.player.angle)
    table.insert(self.projectiles, projectile)
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)
    if testAABB(self.player, asteroid) then
      self.lives = self.lives - 1
      self.player:reset()
      asteroid.inPlay = false
      if self.lives == 0 then
        gStateMachine:change("gameover")
      end
    end
    if not asteroid.inPlay then
      if asteroid.size > 1 then
        table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
        table.insert(self.asteroids, Asteroid:create(asteroid.x, asteroid.y, asteroid.size - 1))
      end
      self.score = self.score + self.points[asteroid.size]
      if self.score > self.hiScore then
        self.hiScore = self.score
      end
      table.remove(self.asteroids, k)
    end
  end

  for k, projectile in pairs(self.projectiles) do
    projectile:update(dt)
    for j, asteroid in pairs(self.asteroids) do
      if testAABB(projectile, asteroid) then
        projectile.inPlay = false
        asteroid.inPlay = false
      end
    end
    if not projectile.inPlay then
      table.remove(self.projectiles, k)
    end
  end

  self.player:update(dt)
end

function PlayState:render()
  self:showStats()

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end
  self.player:render()
end

function PlayState:showStats()
  love.graphics.setColor(gColors["foreground"]["r"], gColors["foreground"]["g"], gColors["foreground"]["b"])
  local x = math.floor(WINDOW_WIDTH / 4)
  local y = 2
  love.graphics.print(self.hiScore, x, y)

  y = y + 20
  love.graphics.printf(self.score, 0, y, x, "right")
  x = x + 4
  for life = 1, self.lives - 1 do
    x = x + 8
    love.graphics.polygon("fill", x, y + 4, x, y + 18, x - 5, y + 14)
  end
end
