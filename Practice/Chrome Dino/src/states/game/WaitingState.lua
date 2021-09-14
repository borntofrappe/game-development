WaitingState = BaseState:new()

local OVERLAY_TWEEN = 0.9

function WaitingState:enter()
    local x = gDino.x + gDino.width + 2
    local y = 0
    self.overlay = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = VIRTUAL_WIDTH - x,
        ["height"] = VIRTUAL_HEIGHT - y
    }

    self.isTransitioning = false
end

function WaitingState:update(dt)
    Timer:update(dt)
    gDino:update(dt)

    if love.keyboard.waspressed("escape") then
        love.event.quit()
    end

    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        if gDino.state == "idle" then
            gDino:changeState("jump")
        end
    end

    if gDino.state == "run" or gDino.state == "duck" then
        gGround.x = gGround.x - SCROLL_SPEED * dt
        if gGround.x <= -gGround.width then
            gGround.x = 0
        end

        if not self.isTransitioning then
            self.isTransitioning = true

            Timer:tween(
                OVERLAY_TWEEN,
                {
                    [self.overlay] = {["x"] = VIRTUAL_WIDTH}
                },
                function()
                    gStateStack:pop()
                    gStateStack:push(PlayingState:new())
                end
            )
        end
    end
end

function WaitingState:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.overlay.x, self.overlay.y, self.overlay.width, self.overlay.height)
end
