PlayState = Class({__includes = BaseState})

function PlayState:init()
end

function PlayState:enter(params)
  self.round = params.round
  self.score = params.score
  self.health = params.health

  self.player = params.player or Player()
  self.bullet = params.bullet or nil
  self.rows = params.rows or self:createRows()

  local x = self.rows[#self.rows][1].x

  for k, row in ipairs(self.rows) do
    for j, alien in ipairs(row) do
      if alien.x ~= x + (j - 1) * (ALIEN_GAP_X + ALIEN_WIDTH) then
        if k == 1 then
          gSounds["move"]:play()
        end
        Timer.after(
          0.1 * (#self.rows - (k + 1)),
          function()
            alien.x = x + (j - 1) * (ALIEN_GAP_X + ALIEN_WIDTH)
          end
        )
      end
    end
  end

  for k, row in ipairs(self.rows) do
    for j, alien in ipairs(row) do
      Timer.after(
        0.1 * (#self.rows - (k + 1)),
        function()
          Timer.every(
            0.6,
            function()
              if k == #self.rows then
                gSounds["move"]:play()
              end
              alien.x = alien.x + alien.direction * alien.dx
              alien.variant = alien.variant == 1 and 2 or 1

              if k == 1 and j == 1 then
                if alien.direction == 1 then
                  if alien.x >= WINDOW_WIDTH - #row * (ALIEN_WIDTH + ALIEN_GAP_X) then
                    gSounds["move"]:stop()
                    gSounds["move"]:play()
                    for k, row in ipairs(self.rows) do
                      for j, alien in ipairs(row) do
                        alien.direction = -1
                        Timer.after(
                          0.05 * (#self.rows - (k + 1)),
                          function()
                            alien.y = alien.y + alien.dy
                          end
                        )
                      end
                    end
                  end
                elseif alien.direction == -1 then
                  if alien.x <= 16 then
                    gSounds["move"]:stop()
                    gSounds["move"]:play()
                    for k, row in ipairs(self.rows) do
                      for j, alien in ipairs(row) do
                        alien.direction = 1
                        Timer.after(
                          0.05 * (#self.rows - (k + 1)),
                          function()
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

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    Timer.clear()
    gStateMachine:change("title")
  end

  Timer.update(dt)

  self.player:update(dt)

  if self.bullet then
    self.bullet:update(dt)

    for k, row in ipairs(self.rows) do
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
        rows = self.rows,
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

  for k, row in ipairs(self.rows) do
    for j, alien in ipairs(row) do
      alien:render()
    end
  end
end

function PlayState:createRows()
  local rows = {}
  local x = 16
  local y = 76

  for row = 1, 5 do
    x = 16
    rows[row] = {}
    local type = 3 - math.floor(row / 2)
    for column = 1, 8 do
      rows[row][column] = Alien(x, y, type)
      x = x + ALIEN_GAP_X + ALIEN_WIDTH
    end

    y = y + ALIEN_GAP_Y + ALIEN_HEIGHT
  end

  return rows
end

function PlayState:checkVictory()
  local hasWon = true
  for k, row in ipairs(self.rows) do
    for j, alien in ipairs(row) do
      if alien.inPlay then
        hasWon = false
        break
      end
    end
  end

  return hasWon
end
