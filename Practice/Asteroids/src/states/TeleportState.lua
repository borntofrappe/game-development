TeleportState = Class {__includes = BaseState}

local DELAY = 0.5

function TeleportState:init()
  self.time = 0
end

function TeleportState:enter(params)
  self.level = params.level
  self.player = params.player
  self.asteroids = params.asteroids

  self.player:teleport()
  -- stop existing audio for consecutive "teleportations"
  gSounds["teleport"]:stop()
  gSounds["teleport"]:play()
end

function TeleportState:update(dt)
  self.time = self.time + dt
  if self.time >= DELAY then
    gStateMachine:change(
      "play",
      {
        level = self.level,
        player = self.player,
        asteroids = self.asteroids
      }
    )
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)
  end
end

function TeleportState:render()
  displayRecord(gRecord.points)
  displayStats(self.player.points, self.player.lives)

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end
end
