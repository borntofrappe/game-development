PauseState = Class {__includes = BaseState}

function PauseState:enter(params)
    sounds["soundtrack"]:pause()
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.interval = params.interval
    self.score = params.score
    self.y = params.y
end

function PauseState:update(dt)
    if love.keyboard.waspressed("p") or love.keyboard.waspressed("p") then
        gStateMachine:change(
            "play",
            {
                bird = self.bird,
                pipePairs = self.pipePairs,
                timer = self.timer,
                interval = self.interval,
                score = self.score,
                y = self.y
            }
        )
    end
end

function PauseState:render()
    love.graphics.setFont(font_big)
    love.graphics.printf("Take a breather", 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(font_normal)
    love.graphics.printf("Press p to resume playing", 0, VIRTUAL_HEIGHT / 2 + 8, VIRTUAL_WIDTH, "center")
end
