SpawnState = Class {__includes = BaseState}

local INTERVAL = 0.3
local LOOPS = 5

function SpawnState:init()
  self.interval = INTERVAL
  self.loops = LOOPS
  self.loop = 0
  self.time = 0

  self.player = Player()
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
          player = self.player
        }
      )
    end
  end

  self.player:update(dt)
end

function SpawnState:render()
  if self.loop % 2 == 0 then
    self.player:render()
  end
end
