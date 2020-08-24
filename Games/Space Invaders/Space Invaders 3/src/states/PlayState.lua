PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.player = Player()
  self.bullet = nil
  self.aliens = {}

  local width = 24
  local height = 21
  local x = WINDOW_WIDTH / 2 - (width + 16) * 4 + 8
  for column = 1, 8 do
    local y = 8
    local alien = Alien(x, y, 1)
    table.insert(self.aliens, alien)

    for row = 1, 4 do
      y = y + 8 + height
      local type = row < 3 and 2 or 3
      local alien = Alien(x, y, type)
      table.insert(self.aliens, alien)
    end
    x = x + 16 + width
  end

  Timer.every(
    1,
    function()
      for k, alien in pairs(self.aliens) do
        alien.variant = alien.variant == 1 and 2 or 1
      end
    end
  )
end

function PlayState:update(dt)
  Timer.update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("title")
  end

  self.player:update(dt)

  if self.bullet then
    self.bullet:update(dt)

    for k, alien in pairs(self.aliens) do
      if testAABB(alien, self.bullet) then
        table.remove(self.aliens, k)
        self.bullet = nil
        break
      end
    end

    if self.bullet and self.bullet.y < -self.bullet.height then
      self.bullet = nil
    end
  end

  if love.keyboard.waspressed("up") or love.keyboard.waspressed("space") then
    if not self.bullet then
      self.bullet = Bullet(self.player.x + self.player.width / 2, self.player.y)
    end
  end
end

function PlayState:render()
  love.graphics.setColor(1, 1, 1, 1)
  if self.bullet then
    self.bullet:render()
  end
  self.player:render()

  for k, alien in pairs(self.aliens) do
    alien:render()
  end
end
