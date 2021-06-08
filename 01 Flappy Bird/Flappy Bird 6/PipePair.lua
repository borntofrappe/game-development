require "Pipe"

PipePair = Class {}
local GAP_HEIGHT = 80

local PAIR_WIDTH = 70
local PAIR_SCROLL = 60

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PAIR_WIDTH
    self.pipes = {
        upper = Pipe(self.x, self.y - GAP_HEIGHT, "top"),
        lower = Pipe(self.x, self.y, "bottom")
    }

    self.remove = false
end

function PipePair:update(dt)
    self.x = self.x - PAIR_SCROLL * dt
    for k, pipe in pairs(self.pipes) do
        pipe.x = self.x
    end

    if self.x < -PAIR_WIDTH then
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
