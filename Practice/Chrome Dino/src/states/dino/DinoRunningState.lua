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
    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        self.dino:changeState("jump")
    end

    if love.keyboard.waspressed("down") then
        self.dino:changeState("duck")
    end
end
