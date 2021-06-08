require "Pipe"

PipePair = Class {}

local GAP_HEIGHT = 80
local PAIR_SCROLL = 60
local PIPE_WIDTH = Pipe().width
local PIPE_HEIGHT = Pipe().height

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_WIDTH
    self.pipes = {
        upper = Pipe(self.x, self.y - GAP_HEIGHT - PIPE_HEIGHT, "top"),
        lower = Pipe(self.x, self.y, "bottom")
    }

    self.scored = false
    self.remove = false
end

function PipePair:update(dt)
    self.x = self.x - PAIR_SCROLL * dt
    for k, pipe in pairs(self.pipes) do
        pipe.x = self.x
    end

    if self.x < -self.width then
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
