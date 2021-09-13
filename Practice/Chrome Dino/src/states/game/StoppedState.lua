StoppedState = BaseState:new()

function StoppedState:enter()
    gDino:changeState("stop")
end

function StoppedState:update(dt)
    if love.keyboard.waspressed("escape") or love.keyboard.waspressed("return") then
        gStateStack:pop()
        gStateStack:pop()
        gStateStack:push(WaitingState:new())
    end

    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        gStateStack:pop()
        gStateStack:pop()
        gStateStack:push(PlayingState:new())

        gDino.y = gDino.yStart
        gDino:changeState("jump")
    end
end
