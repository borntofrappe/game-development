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

    if love.keyboard.waspressed("right") then
        self.dino:changeState("run")
    end

    if love.keyboard.waspressed("left") then
        self.dino:changeState("stop")
    end

    if love.keyboard.waspressed("down") then
        self.dino:changeState("duck")
    end
end
