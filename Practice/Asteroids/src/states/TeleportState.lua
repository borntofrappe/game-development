TeleportState = Class {__includes = BaseState}

local DELAY = 0.5

function TeleportState:init()
  self.time = 0
end

function TeleportState:enter(params)
  self.asteroids = params.asteroids
end

function TeleportState:update(dt)
  self.time = self.time + dt
  if self.time >= DELAY then
    gStateMachine:change(
      "play",
      {
        player = Player(),
        asteroids = self.asteroids
      }
    )
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)
  end
end

function TeleportState:render()
  displayRecord()
  displayStats(gStats)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end
end
