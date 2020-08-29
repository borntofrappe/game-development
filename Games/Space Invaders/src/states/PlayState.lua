PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.particles = {}
  self.gameover = false
end

function PlayState:enter(params)
  self.player = params.player
  self.bullet = params.bullet
  self.aliens = params.aliens
  self.bullets = params.bullets
  self.bonus = params.bonus

  self.round = params.round
  self.score = params.score
  self.hasRecord = params.hasRecord
  self.health = params.health
  self.hits = params.hits
  self.speed = params.speed

  self:moveAliens()
end

function PlayState:exit()
  Timer.clear()
end

function PlayState:update(dt)
  if self.gameover then
    gStateMachine:change(
      "hit",
      {
        player = self.player,
        bullet = self.bullet,
        aliens = self.aliens,
        bullets = self.bullets,
        bonus = self.bonus,
        round = self.round,
        score = self.score,
        hasRecord = self.hasRecord,
        health = 0,
        hits = self.hits,
        speed = self.speed,
        particles = self.particles
      }
    )
  end

  Timer.update(dt)

  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end

  self.player:update(dt)

  if self.bullet then
    self.bullet:update(dt)

    for i, row in ipairs(self.aliens) do
      for j, alien in ipairs(row) do
        if self.bullet and alien.inPlay and testAABB(alien, self.bullet) then
          gSounds["hit"]:play()
          alien.inPlay = false

          self.bullet = nil
          self.score = self.score + 10 * alien.type
          if self.score >= gRecord and not self.hasRecord then
            gSounds["record"]:play()
            self.hasRecord = true
          end

          self.hits = self.hits + 1

          if self.hits >= 8 then
            Timer.clear()
            self.hits = 0
            self.speed = self.speed + 0.15
            self:moveAliens()
          end

          table.insert(
            self.particles,
            {
              x = alien.x,
              y = alien.y,
              type = 1,
              dt = 0
            }
          )

          if self:checkVictory() then
            gSounds["menu"]:play()
            gStateMachine:change(
              "round",
              {
                round = self.round + 1,
                score = self.score,
                health = self.health,
                hasRecord = self.hasRecord
              }
            )
          end

          if alien.lastRow then
            alien.lastRow = false
            for row = alien.row - 1, 1, -1 do
              if self.aliens[row][alien.column].inPlay then
                self.aliens[row][alien.column].lastRow = true
                break
              end
            end
          end

          if alien.bounceFirst then
            alien.bounceFirst = false
            for column = alien.column + 1, COLUMNS do
              for row = 1, ROWS do
                if self.aliens[row][column].inPlay then
                  self.aliens[row][column].bounceFirst = true
                  break
                end
              end
            end
          end

          if alien.bounceLast then
            alien.bounceLast = false
            for column = alien.column - 1, 1, -1 do
              for row = 1, ROWS do
                if self.aliens[row][column].inPlay then
                  self.aliens[row][column].bounceLast = true
                  break
                end
              end
            end
          end

          if alien.isLast then
            alien.isLast = false
            for row = alien.row, 1, -1 do
              for column = COLUMNS, 1, -1 do
                if self.aliens[row][column].inPlay then
                  self.aliens[row][column].isLast = true
                  break
                end
              end
            end
          end

          if not self.bonus and math.random(10) == 1 then
            -- temporary audio file
            gSounds["record"]:play()
            self.bonus = AlienBonus()
          end

          break
        end
      end
    end
  end

  if self.bullet and self.bullet.y < 0 then
    table.insert(
      self.particles,
      {
        x = self.bullet.x + self.bullet.width / 2 - BULLET_PARTICLES_WIDTH / 2,
        y = 0,
        type = 2,
        dt = 0
      }
    )

    self.bullet = nil
  end

  for i, bullet in ipairs(self.bullets) do
    bullet:update(dt)

    if testAABB(bullet, self.player) then
      table.remove(self.bullets, i)

      gStateMachine:change(
        "hit",
        {
          player = self.player,
          bullet = self.bullet,
          aliens = self.aliens,
          bullets = self.bullets,
          bonus = self.bonus,
          round = self.round,
          score = self.score,
          hasRecord = self.hasRecord,
          health = self.health,
          hits = self.hits,
          speed = self.speed,
          particles = self.particles
        }
      )
    end

    if bullet.y > WINDOW_HEIGHT then
      table.insert(
        self.particles,
        {
          x = bullet.x + bullet.width / 2 - BULLET_PARTICLES_WIDTH / 2,
          y = WINDOW_HEIGHT - BULLET_PARTICLES_HEIGHT,
          type = 3,
          dt = 0
        }
      )

      table.remove(self.bullets, i)
    end
  end

  if self.bonus then
    self.bonus:update(dt)
    if self.bullet and testAABB(self.bonus, self.bullet) then
      gSounds["hit"]:play()
      self.bonus.inPlay = false
      self.bullet = nil
      self.score = self.score + 100 + math.random(10) * 10

      table.insert(
        self.particles,
        {
          x = self.bonus.x + self.bonus.width / 2 - BULLET_PARTICLES_WIDTH / 2,
          y = self.bonus.y + self.bonus.height / 2 - BULLET_PARTICLES_HEIGHT / 2,
          type = 1,
          dt = 0
        }
      )
    end
    if not self.bonus.inPlay then
      self.bonus = nil
    end
  end

  for i, particle in ipairs(self.particles) do
    particle.dt = particle.dt + dt
    if particle.dt >= 0.25 then
      table.remove(self.particles, i)
    end
  end

  if love.keyboard.waspressed("up") or love.keyboard.waspressed("space") then
    if not self.bullet then
      gSounds["shoot"]:stop()
      gSounds["shoot"]:play()
      self.bullet = Bullet(self.player.x + self.player.width / 2, self.player.y, -1)
    end
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    gSounds["pause"]:play()
    gStateMachine:change(
      "pause",
      {
        player = self.player,
        bullet = self.bullet,
        aliens = self.aliens,
        bullets = self.bullets,
        bonus = self.bonus,
        round = self.round,
        score = self.score,
        hasRecord = self.hasRecord,
        health = self.health,
        hits = self.hits,
        speed = self.speed,
        particles = self.particles
      }
    )
  end
end

function PlayState:render()
  showGameInfo(
    {
      score = self.score,
      health = self.health
    }
  )

  love.graphics.setColor(1, 1, 1, 1)

  if self.bullet then
    self.bullet:render()
  end

  self.player:render()

  for i, bullet in ipairs(self.bullets) do
    bullet:render()
  end

  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      alien:render()
    end
  end

  for i, particle in ipairs(self.particles) do
    love.graphics.draw(gTextures["spritesheet"], gFrames["particles"][particle.type], particle.x, particle.y)
  end

  if self.bonus then
    self.bonus:render()
  end
end

function PlayState:moveAliens()
  local x = self.aliens[#self.aliens][1].x
  local y = self.aliens[#self.aliens][1].y

  local delay = 0.1 / self.speed
  local interval = 0.6 / self.speed
  local stagger = 0.04 / self.speed

  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      if
        alien.x ~= x + (j - 1) * (ALIEN_GAP_X + ALIEN_WIDTH) or
          alien.y ~= y - (#self.aliens - i) * (ALIEN_GAP_Y + ALIEN_HEIGHT)
       then
        if alien.isLast then
          gSounds["move"]:play()
        end
        Timer.after(
          delay * (#self.aliens - (i + 1)),
          function()
            alien.x = x + (j - 1) * (ALIEN_GAP_X + ALIEN_WIDTH)
            alien.y = y - (#self.aliens - i) * (ALIEN_GAP_Y + ALIEN_HEIGHT)
          end
        )
      end
    end
  end

  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      Timer.after(
        delay * (#self.aliens - (i + 1)),
        function()
          Timer.every(
            interval,
            function()
              if alien.isLast then
                gSounds["move"]:play()
              end
              alien.x = alien.x + alien.direction * alien.dx
              alien.variant = alien.variant == 1 and 2 or 1

              if alien.lastRow and #self.bullets < 3 then
                local odds = 24
                if math.abs((alien.x + alien.width / 2) - (self.player.x + self.player.width / 2)) < WINDOW_WIDTH / 8 then
                  odds = 8
                end
                if math.random(odds) == 1 then
                  gSounds["shoot"]:stop()
                  gSounds["shoot"]:play()
                  table.insert(self.bullets, Bullet(alien.x + alien.width / 2, alien.y + alien.height, 0.5))
                end
              end

              if alien.direction == 1 then
                if alien.bounceLast then
                  if alien.x >= WINDOW_WIDTH - (ALIEN_WIDTH + 16) then
                    gSounds["move"]:stop()
                    gSounds["move"]:play()
                    for i, row in ipairs(self.aliens) do
                      for j, alien in ipairs(row) do
                        Timer.after(
                          stagger * (#self.aliens - (i + 1)),
                          function()
                            alien.direction = -1
                            alien.y = alien.y + alien.dy
                            if alien.isLast and alien.y + alien.height >= self.player.y then
                              self.gameover = true
                            end
                          end
                        )
                      end
                    end
                  end
                end
              elseif alien.direction == -1 then
                if alien.bounceFirst then
                  if alien.x <= 16 then
                    gSounds["move"]:stop()
                    gSounds["move"]:play()
                    for i, row in ipairs(self.aliens) do
                      for j, alien in ipairs(row) do
                        Timer.after(
                          stagger * (#self.aliens - (i + 1)),
                          function()
                            alien.direction = 1
                            alien.y = alien.y + alien.dy
                            if alien.isLast and alien.y + alien.height >= self.player.y then
                              self.gameover = true
                            end
                          end
                        )
                      end
                    end
                  end
                end
              end
            end
          )
        end
      )
    end
  end
end

function PlayState:checkVictory()
  local hasWon = true
  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      if alien.inPlay then
        hasWon = false
        break
      end
    end
  end

  return hasWon
end
