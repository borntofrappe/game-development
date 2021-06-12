VictoryState = Class {__includes = BaseState}

local DELAY = 2

function VictoryState:init()
  self.time = 0

  gSounds["victory"]:play()
end

function VictoryState:enter(params)
  self.player = params.player
  self.level = params.level

  self.level = self.level + 1

  self.asteroids = {}
  for i = 1, self.level * ASTEROIDS_PER_LEVEL do
    table.insert(self.asteroids, Asteroid())
  end
end

function VictoryState:update(dt)
  if self.time >= DELAY then
    gStateMachine:change(
      "play",
      {
        level = self.level,
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
  displayRecord(gRecord.points)
  displayStats(self.player.points, self.player.lives)
  self.player:render()
end
