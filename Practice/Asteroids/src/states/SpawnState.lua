SpawnState = Class {__includes = BaseState}

local INTERVAL = 0.3
local LOOPS = 5
local ASTEROIDS = 3

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
    for i = 1, ASTEROIDS do
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
  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  if self.loop % 2 == 0 then
    self.player:render()
  end
end
