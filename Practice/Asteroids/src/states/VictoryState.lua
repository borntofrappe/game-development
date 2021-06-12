VictoryState = Class {__includes = BaseState}

local DELAY = 2

function VictoryState:init()
  self.time = 0
end

function VictoryState:enter(params)
  self.player = params.player
  gStats.level = gStats.level + 1

  self.asteroids = {}
  for i = 1, gStats.level * ASTEROIDS_PER_LEVEL do
    table.insert(self.asteroids, Asteroid())
  end
end

function VictoryState:update(dt)
  if self.time >= DELAY then
    gStateMachine:change(
      "play",
      {
        player = self.player,
        asteroids = self.asteroids
      }
    )
  else
    self.time = self.time + dt
    self.player:update(dt)
  end
end

function VictoryState:render()
  displayRecord()
  displayStats()
  self.player:render()
end
