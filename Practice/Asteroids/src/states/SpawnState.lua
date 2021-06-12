SpawnState = Class {__includes = BaseState}

local INTERVAL = 0.25
local LOOPS = 7

function SpawnState:init()
  self.interval = INTERVAL
  self.loops = LOOPS
  self.loop = 0
  self.time = 0
end

function SpawnState:enter(params)
  self.player = params and params.player or Player()
  self.asteroids = params and params.asteroids or {}

  if not params then
    for i = 1, gStats.level * ASTEROIDS_PER_LEVEL do
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
  displayRecord()

  if self.loop % 2 == 0 then
    displayStats(gStats)
    self.player:render()
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end
end
