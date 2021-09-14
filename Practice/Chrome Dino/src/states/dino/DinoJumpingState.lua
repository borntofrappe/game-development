DinoJumpingState = BaseState:new()

local GRAVITY = 10
local JUMP = 3.5

function DinoJumpingState:new(dino)
    local this = {
        ["dino"] = dino
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function DinoJumpingState:enter()
    self.dino.dy = -JUMP
end

function DinoJumpingState:update(dt)
    self.dino.dy = self.dino.dy + GRAVITY * dt
    self.dino.y = self.dino.y + self.dino.dy

    if self.dino.y >= self.dino.yStart then
        self.dino.y = self.dino.yStart

        if love.keyboard.isDown("down") then
            self.dino:changeState("duck")
        else
            self.dino:changeState("run")
        end
    end
end
