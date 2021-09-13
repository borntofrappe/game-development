DinoJumpingState = BaseState:new()

function DinoJumpingState:new(dino)
    dino.y = dino.y - 5
    local this = {
        ["dino"] = dino
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function DinoJumpingState:exit()
    self.dino.y = self.dino.y + 5
end

function DinoJumpingState:update(dt)
    if love.keyboard.waspressed("space") then
        self.dino:changeState("idle")
    end
end
