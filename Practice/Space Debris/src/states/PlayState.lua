PlayState = BaseState:new()

local INTERVAL_CHANGE = 0.1
local INTERVAL_MAX = 1.5
local INTERVAL_MIN = 1

function PlayState:enter()
  self.timer = 0
  self.interval = INTERVAL_MAX
  self.seconds = 0

  self.spaceship = Spaceship:new()
  self.debris = {Debris:new()}
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end

  self.timer = self.timer + dt
  self.seconds = self.seconds + dt

  if self.timer >= self.interval then
    self.timer = self.timer % self.interval
    if self.interval > INTERVAL_MIN and math.random(2) == 1 then
      self.interval = math.max(INTERVAL_MIN, self.interval - INTERVAL_CHANGE)
    end

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

    local x, y, dx, dy = self.spaceship:collides(deb)
    if x then
      gSounds["collision"]:play()

      gStateMachine:change(
        "gameover",
        {
          ["seconds"] = self.seconds,
          ["x"] = x,
          ["y"] = y,
          ["dx"] = dx,
          ["dy"] = dy,
          ["debris"] = self.debris
        }
      )
    end

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
