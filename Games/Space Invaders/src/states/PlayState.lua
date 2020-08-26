PlayState = Class({__includes = BaseState})

function PlayState:init()
end

function PlayState:enter(params)
  self.player = params.player or Player()
  self.bullet = params.bullet or nil
  self.aliens = params.aliens or self:createAliens()

  self.speed = params.speed or 1
  self.round = params.round
  self.score = params.score
  self.health = params.health

  self:moveAliens()
end

function PlayState:update(dt)
  if love.keyboard.waspressed("s") then
    Timer.clear()
    self.speed = self.speed + 0.1
    self:moveAliens()
  end

  if love.keyboard.waspressed("g") then
    Timer.clear()
    gSounds["explosion"]:play()
    gStateMachine:change("gameover")
  end

  if love.keyboard.waspressed("escape") then
    Timer.clear()
    gStateMachine:change("title")
  end

  Timer.update(dt)

  self.player:update(dt)

  if self.bullet then
    self.bullet:update(dt)

    for k, row in ipairs(self.aliens) do
      for j, alien in ipairs(row) do
        if self.bullet and alien.inPlay and testAABB(alien, self.bullet) then
          gSounds["hit"]:play()
          alien.inPlay = false
          self.bullet = nil
          self.score = self.score + 10 * alien.type

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

          if alien.isFirst then
            alien.isFirst = false
            for column = alien.column + 1, COLUMNS do
              for row = 1, ROWS do
                if self.aliens[row][column].inPlay then
                  self.aliens[row][column].isFirst = true
                  break
                end
              end
            end
          end

          if alien.isLast then
            alien.isLast = false
            for column = alien.column - 1, 1, -1 do
              for row = 1, ROWS do
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

  if self.bullet and self.bullet.y < -self.bullet.height then
    self.bullet = nil
  end

  if love.keyboard.waspressed("up") or love.keyboard.waspressed("space") then
    if not self.bullet then
      gSounds["shoot"]:play()
      self.bullet = Bullet(self.player.x + self.player.width / 2, self.player.y)
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
        round = self.round,
        score = self.score,
        health = self.health
      }
    )
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

  for k, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      alien:render()
    end
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
  local stagger = 0.05 / self.speed

  for k, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      if
        alien.x ~= x + (j - 1) * (ALIEN_GAP_X + ALIEN_WIDTH) or
          alien.y ~= y - (#self.aliens - k) * (ALIEN_GAP_Y + ALIEN_HEIGHT)
       then
        if k == 1 then
          gSounds["move"]:play()
        end
        Timer.after(
          delay * (#self.aliens - (k + 1)),
          function()
            alien.x = x + (j - 1) * (ALIEN_GAP_X + ALIEN_WIDTH)
            alien.y = y - (#self.aliens - k) * (ALIEN_GAP_Y + ALIEN_HEIGHT)
          end
        )
      end
    end
  end

  for k, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      Timer.after(
        delay * (#self.aliens - (k + 1)),
        function()
          Timer.every(
            interval,
            function()
              if k == #self.aliens then
                gSounds["move"]:play()
              end
              alien.x = alien.x + alien.direction * alien.dx
              alien.variant = alien.variant == 1 and 2 or 1

              if alien.direction == 1 then
                if alien.isLast then
                  if alien.x >= WINDOW_WIDTH - (ALIEN_WIDTH + 16) then
                    gSounds["move"]:stop()
                    gSounds["move"]:play()
                    for k, row in ipairs(self.aliens) do
                      for j, alien in ipairs(row) do
                        Timer.after(
                          stagger * (#self.aliens - (k + 1)),
                          function()
                            alien.direction = -1
                            alien.y = alien.y + alien.dy
                          end
                        )
                      end
                    end
                  end
                end
              elseif alien.direction == -1 then
                if alien.isFirst then
                  if alien.x <= 16 then
                    gSounds["move"]:stop()
                    gSounds["move"]:play()
                    for k, row in ipairs(self.aliens) do
                      for j, alien in ipairs(row) do
                        Timer.after(
                          stagger * (#self.aliens - (k + 1)),
                          function()
                            alien.direction = 1
                            alien.y = alien.y + alien.dy
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
  for k, row in ipairs(self.aliens) do
    for j, alien in ipairs(row) do
      if alien.inPlay then
        hasWon = false
        break
      end
    end
  end

  return hasWon
end
