PlayState = BaseState:new()

local INTERVAL = 1.5

function PlayState:enter()
  self.timer = 0

  self.spaceship = Spaceship:new()
  self.debris = {Debris:new()}
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  self.timer = self.timer + dt
  if self.timer >= INTERVAL then
    self.timer = self.timer % INTERVAL

    table.insert(self.debris, Debris:new(self.debris[#self.debris]))
  end

  self.spaceship:update(dt)

  if love.keyboard.isDown("up") then
    self.spaceship:thrust()

    gSounds["thrust"]:stop()
    gSounds["thrust"]:play()
  end

  for k, deb in pairs(self.debris) do
    deb:update(dt)

    if deb.x < -deb.width or deb.x > VIRTUAL_WIDTH then
      table.remove(self.debris, k)
    end
  end
end

function PlayState:render()
  for k, deb in pairs(self.debris) do
    deb:render()
  end

  self.spaceship:render()
end
