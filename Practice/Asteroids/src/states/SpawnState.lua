SpawnState = Class {__includes = BaseState}

local INTERVAL = 0.25
local LOOPS = 7

function SpawnState:init()
  self.interval = INTERVAL
  self.loops = LOOPS
  self.loop = 0
  self.time = 0

  gSounds["spawn"]:play()
end

function SpawnState:enter(params)
  self.level = params.level or 1
  self.player = params.player or Player()
  self.asteroids = params.asteroids or {}

  if not params.asteroids then
    for i = 1, 1 do
      table.insert(self.asteroids, Asteroid())
    end
  end
end

function SpawnState:update(dt)
  self.time = self.time + dt
  if self.time >= self.interval then
    self.time = self.time % self.interval
    self.loop = self.loop + 1
    if self.loop == self.loops then
      gStateMachine:change(
        "play",
        {
          level = self.level,
          player = self.player,
          asteroids = self.asteroids
        }
      )
    end
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)
  end

  self.player:update(dt)
end

function SpawnState:render()
  displayRecord(gRecord)

  if self.loop % 2 == 0 then
    displayStats(self.player.points, self.player.lives)
    self.player:render()
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end
end
