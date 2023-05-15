PauseState = Class({__includes = BaseState})

function PauseState:init()
    local text_message = "Pause"
    local width_message = gFont:getWidth(text_message)
    local height_message = gFont:getHeight()
    self.message = {
        ["text"] = text_message,
        ["x"] = 0,
        ["y"] = VIRTUAL_HEIGHT / 2 - height_message / 2,
        ["width"] = VIRTUAL_WIDTH,
        ["align"] = "center"
    }
end

function PauseState:enter(params)
    self.gravity = params.gravity
    self.direction = params.direction
    self.timer = params.timer
    self.timer_progress = params.timer_progress
    self.player = params.player
    self.trophy = params.trophy
end

function PauseState:update(dt)
    if love.keyboard.was_pressed("escape") then
        love.event.quit()
    end

    if love.keyboard.was_pressed("p") or love.mouse.button_pressed[2] then
        gStateMachine:change(
            "play",
            {
                ["gravity"] = self.gravity,
                ["direction"] = self.direction,
                ["timer"] = self.timer,
                ["timer_progress"] = self.timer_progress,
                ["player"] = self.player,
                ["trophy"] = self.trophy
            }
        )
    end
end

function PauseState:render()
    love.graphics.setColor(1, 1, 1, 1)
    self.player:render()

    drawOverlay()

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf(
        self.message["text"],
        self.message["x"],
        self.message["y"],
        self.message["width"],
        self.message["align"]
    )
end
