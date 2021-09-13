DinoDuckingState = BaseState:new()

function DinoDuckingState:new(dino)
    local this = {
        ["dino"] = dino
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function DinoDuckingState:update(dt)
    if love.keyboard.waspressed("space") then
        self.dino:changeState("idle")
    end
end
