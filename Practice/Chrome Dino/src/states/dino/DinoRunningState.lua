DinoRunningState = BaseState:new()

function DinoRunningState:new(dino)
    local this = {
        ["dino"] = dino
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function DinoRunningState:update(dt)
    if love.keyboard.waspressed("space") then
        self.dino:changeState("idle")
    end
end
