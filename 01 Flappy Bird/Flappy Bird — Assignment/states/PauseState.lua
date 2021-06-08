PauseState = Class {__includes = BaseState}

function PauseState:enter(params)
    self.image = love.graphics.newImage("res/graphics/pause-icon.png")
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.interval = params.interval
    self.score = params.score
    self.y = params.y

    sounds["soundtrack"]:pause()
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
    love.graphics.printf("Take a breather", 0, VIRTUAL_HEIGHT / 2 - font_big:getHeight(), VIRTUAL_WIDTH, "center")

    love.graphics.setFont(font_normal)
    love.graphics.printf("Press p to resume playing", 0, VIRTUAL_HEIGHT / 2 + 12, VIRTUAL_WIDTH, "center")

    love.graphics.draw(
        self.image,
        VIRTUAL_WIDTH / 2 - self.image:getWidth() / 2,
        VIRTUAL_HEIGHT / 2 + 12 + 12 + font_normal:getHeight()
    )
end
