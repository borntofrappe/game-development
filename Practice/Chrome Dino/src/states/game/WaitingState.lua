WaitingState = BaseState:new()

local OVERLAY_TWEEN = 0.9

function WaitingState:enter()
    self.ground = Ground:new()
    self.dino = Dino:new(self.ground)

    local xOverlay = self.dino.x + self.dino.width + 2
    self.overlay = {
        ["x"] = xOverlay,
        ["y"] = 0,
        ["width"] = VIRTUAL_WIDTH - xOverlay,
        ["height"] = VIRTUAL_HEIGHT,
        ["tween"] = OVERLAY_TWEEN
    }

    self.isTweening = false
end

function WaitingState:update(dt)
    if love.keyboard.waspressed("escape") then
        love.event.quit()
    end

    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        if self.dino.state == "idle" then
            self.dino:changeState("jump")
        end
    end

    Timer:update(dt)

    self.dino:update(dt)

    if self.dino.state == "run" or self.dino.state == "duck" then
        self.ground.x = self.ground.x - SCROLL_SPEED * dt
        if self.ground.x <= -self.ground.width then
            self.ground.x = 0
        end

        if not self.isTweening then
            self.isTweening = true

            Timer:tween(
                self.overlay.tween,
                {
                    [self.overlay] = {["x"] = VIRTUAL_WIDTH}
                },
                function()
                    gStateMachine:change(
                        "play",
                        {
                            ["ground"] = self.ground,
                            ["dino"] = self.dino
                        }
                    )
                end
            )
        end
    end
end

function WaitingState:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self.ground:render()
    self.dino:render()

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.overlay.x, self.overlay.y, self.overlay.width, self.overlay.height)
end
