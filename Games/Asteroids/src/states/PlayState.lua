PlayState = BaseState:create()

function PlayState:enter(params)
  self.points = {
    [3] = 20,
    [2] = 50,
    [1] = 100
  }

  self.score = params.score or 0
  self.hiScore = params.hiScore or 3500
  self.lives = params.lives or 3

  self.player = params.player or Player:create()
  self.projectiles = params.projectiles or {}
  self.numberAsteroids = params.numberAsteroids or params.difficulty * 2
  self.asteroids = params.asteroids or self:createLevel()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change(
      "pause",
      {
        score = self.score,
        hiScore = self.hiScore,
        lives = self.lives,
        player = self.player,
        projectiles = self.projectiles,
        numberAsteroids = self.numberAsteroids,
        asteroids = self.asteroids
      }
    )
  end

  if love.keyboard.wasPressed("space") then
    local projectile = Projectile:create(self.player.x, self.player.y, self.player.angle)
    table.insert(self.projectiles, projectile)
  end

  if love.keyboard.wasPressed("down") or love.keyboard.wasPressed("s") then
    local isSearching = true
    local x
    local y
    while (isSearching) do
      x = math.random(0, WINDOW_WIDTH)
      y = math.random(0, WINDOW_HEIGHT)
      local player = Player:create(x, y)

      local isValid = true
      for k, asteroid in pairs(self.asteroids) do
        if testAABB(player, asteroid) then
          isValid = false
          break
        end
      end
      if isValid then
        isSearching = false
      end
    end

    self.player.x = x
    self.player.y = y
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

      if self:hasWon() then
        gStateMachine:change(
          "victory",
          {
            score = self.score,
            hiScore = self.hiScore,
            lives = self.lives,
            numberAsteroids = self.numberAsteroids
          }
        )
      end
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
  showStats(self.score, self.hiScore, self.lives)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  for k, projectile in pairs(self.projectiles) do
    projectile:render()
  end
  self.player:render()
end

function PlayState:createLevel()
  local asteroids = {}
  for i = 1, self.numberAsteroids do
    table.insert(asteroids, Asteroid:create())
  end
  return asteroids
end

function PlayState:hasWon()
  return #self.asteroids == 0
end
