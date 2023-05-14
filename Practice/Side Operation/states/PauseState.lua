PauseState = Class({__includes = BaseState})

function PauseState:enter(params)
    self.gravity = params.gravity
    self.direction = params.direction
    self.timer = params.timer
    self.progress = params.progress
    self.player = params.player
end

function PauseState:update(dt)
    if love.keyboard.was_pressed("p") or love.keyboard.was_pressed("return") then
        gStateMachine:change(
            "play",
            {
                ["gravity"] = self.gravity,
                ["direction"] = self.direction,
                ["timer"] = self.timer,
                ["progress"] = self.progress,
                ["player"] = self.player
            }
        )
    end
end

function PauseState:render()
    love.graphics.setColor(1, 1, 1, 1)
    self.player:render()

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf("Pause", 0, VIRTUAL_HEIGHT / 2 - gFont:getHeight() / 2, VIRTUAL_WIDTH, "center")
end
