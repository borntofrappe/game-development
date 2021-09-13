PlayingState = BaseState:new()

function PlayingState:enter()
    self.cloud = Cloud:new()
end

function PlayingState:update(dt)
    gDino:update(dt)

    self.cloud:update(dt)
    if not self.cloud.inPlay then
        self.cloud = Cloud:new()
    end

    gGround.x = gGround.x - SCROLL_SPEED * dt
    if gGround.x <= -gGround.width then
        gGround.x = 0
    end

    if love.keyboard.waspressed("escape") then
        Timer:reset()
        gStateStack:pop()
        gStateStack:push(WaitingState:new())
    end
end

function PlayingState:render()
    self.cloud:render()
end

function PlayingState:exit()
    gDino:changeState("idle")
    gGround.x = 0
end
