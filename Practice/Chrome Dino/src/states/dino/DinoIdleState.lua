DinoIdleState = BaseState:new()

function DinoIdleState:new(dino)
    local this = {
        ["dino"] = dino
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function DinoIdleState:update(dt)
    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        self.dino:changeState("jump")
    end
end
