WaitingState = BaseState:new()

local OVERLAY_TWEEN = 0.84
local OVERLAY_OFFSET = 2

function WaitingState:enter()
    self.ground = Ground:new()
    self.dino = Dino:new(self.ground)
    self.score = Score:new()

    local xOverlay = self.dino.x + self.dino.width + OVERLAY_OFFSET
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

    if self.dino.state ~= "idle" then
        self.ground.x = self.ground.x - SCROLL_SPEED.min * dt
        if self.ground.x <= -self.ground.width then
            self.ground.x = 0
        end

        self.score.current = math.min(SCORE_MAX, self.score.current + SCROLL_SPEED.min * SCORE_SPEED * dt)

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
                            ["dino"] = self.dino,
                            ["score"] = self.score
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
    self.score:render()

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.overlay.x, self.overlay.y, self.overlay.width, self.overlay.height)
end
