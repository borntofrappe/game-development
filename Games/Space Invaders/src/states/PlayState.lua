PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.gameover = false
  self.isTweening = false
end

function PlayState:enter(params)
  self.player = params.player or Player()
  self.bullet = params.bullet or nil
  self.aliens = params.aliens or self:createAliens()
  self.bullets = params.bullets or {}

  self.speed = params.speed or 1
  self.round = params.round
  self.score = params.score
  self.health = params.health
  self.hits = params.hits or 0

  self.particles = {}

  self:moveAliens()
end

function PlayState:update(dt)
  if self.gameover then
    if not self.isTweening then
      Timer.clear()
      self.isTweening = true
      self.player.inPlay = false

      local i = #self.particles + 1
      local types = {4, 5}
      self.particles[i] = {
        x = self.player.x + self.player.width / 2 - PLAYER_PARTICLES_WIDTH / 2,
        y = self.player.y + self.player.height / 2 - PLAYER_PARTICLES_HEIGHT / 2,
        type = types[1]
      }

      gSounds["explosion"]:play()
      Timer.every(
        0.5,
        function()
          self.particles[i].type = self.particles[i].type == types[1] and types[2] or types[1]
        end
      )
      Timer.after(
        2.5,
        function()
          gStateMachine:change(
            "gameover",
            {
              score = self.score
            }
          )
        end
      )
    end

    Timer.update(dt)
  else
    -- developer options, just to test how different features
    -- increase speed
    if love.keyboard.waspressed("s") then
      Timer.clear()
      self.speed = self.speed + 0.15
      self:moveAliens()
    end

    -- reduce health
    if love.keyboard.waspressed("h") then
      self.health = self.health - 1
      if self.health == 0 then
        self.gameover = true
      end
    end

    -- immediate gameover
    if love.keyboard.waspressed("g") then
      self.gameover = true
    end

    -- add 1k points
    if love.keyboard.waspressed("p") then
      self.score = self.score + 1000
    end

    if love.keyboard.waspressed("escape") then
      Timer.clear()
      gStateMachine:change("title")
    end

    Timer.update(dt)

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
            self.hits = self.hits + 1

            if self.hits >= 8 then
              self.hits = 0
              self.speed = self.speed + 0.15
              Timer.clear()
              self:moveAliens()
            end

            local i = #self.particles + 1

            self.particles[i] = {
              x = alien.x,
              y = alien.y,
              type = 1
            }

            Timer.after(
              0.25,
              function()
                self.particles[i] = nil
              end
            )

            if self:checkVictory() then
              Timer.clear()
              gSounds["menu"]:play()
              gStateMachine:change(
                "round",
                {
                  round = self.round + 1,
                  score = self.score,
                  health = self.health
                }
              )
            end

            if alien.lastRow then
              alien.lastRow = false
              for row = alien.row - 1, 1, -1 do
                if self.aliens[row][alien.column].inPlay then
                  self.aliens[row][alien.column].lastRow = true
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

            break
          end
        end
      end
    end

    if self.bullet and self.bullet.y < 0 then
      local i = #self.particles + 1
      self.particles[i] = {
        x = self.bullet.x + self.bullet.width / 2 - BULLET_PARTICLES_WIDTH / 2,
        y = 0,
        type = 2
      }

      Timer.after(
        0.25,
        function()
          self.particles[i] = nil
        end
      )

      self.bullet = nil
    end

    for i, bullet in ipairs(self.bullets) do
      bullet:update(dt)

      if bullet.y > WINDOW_HEIGHT - bullet.height then
        local i = #self.particles + 1
        self.particles[i] = {
          x = bullet.x + bullet.width / 2 - BULLET_PARTICLES_WIDTH / 2,
          y = WINDOW_HEIGHT - BULLET_PARTICLES_HEIGHT,
          type = 3
        }

        Timer.after(
          0.25,
          function()
            self.particles[i] = nil
          end
        )

        table.remove(self.bullets, i)
      end
    end

    if love.keyboard.waspressed("up") or love.keyboard.waspressed("space") then
      if not self.bullet then
        gSounds["shoot"]:play()
        self.bullet = Bullet(self.player.x + self.player.width / 2, self.player.y, -1)
      end
    end

    if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
      Timer.clear()
      gSounds["pause"]:play()
      gStateMachine:change(
        "pause",
        {
          player = self.player,
          bullet = self.bullet,
          aliens = self.aliens,
          bullets = self.bullets,
          particles = self.particles,
          round = self.round,
          score = self.score,
          health = self.health,
          hits = self.hits
        }
      )
    end
  end
end

function PlayState:render()
  showInfo(
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

  for i, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      alien:render()
    end
  end

  for i, bullet in ipairs(self.bullets) do
    bullet:render()
  end

  for i, particle in ipairs(self.particles) do
    love.graphics.draw(gTextures["space-invaders"], gFrames["particles"][particle.type], particle.x, particle.y)
  end
end

function PlayState:createAliens()
  local aliens = {}

  for row = 1, ROWS do
    aliens[row] = {}
    for column = 1, COLUMNS do
      local alien = Alien(row, column)
      aliens[row][column] = alien
    end
  end

  return aliens
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

              if alien.lastRow and math.random(20) == 1 then
                local i = #self.bullets + 1
                self.bullets[i] = Bullet(alien.x + alien.width / 2, alien.y + alien.height, 0.5)
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
