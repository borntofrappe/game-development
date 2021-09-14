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
    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        self.dino:changeState("jump")
    end

    if not love.keyboard.isDown("down") then
        self.dino:changeState("run")
    end
end
