StoppedState = BaseState:new()

function StoppedState:enter(params)
    self.ground = params.ground
    self.dino = params.dino

    self.dino:changeState("stop")

    self.clouds = params.clouds
    self.cacti = params.cacti
    self.bird = params.bird
end

function StoppedState:update(dt)
    if love.keyboard.waspressed("escape") or love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        gStateMachine:change("wait")
    end
end

function StoppedState:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self.ground:render()
    self.dino:render()

    for k, cloud in pairs(self.clouds) do
        cloud:render()
    end

    for k, cactus in pairs(self.cacti) do
        cactus:render()
    end

    if self.bird then
        self.bird:render()
    end
end
