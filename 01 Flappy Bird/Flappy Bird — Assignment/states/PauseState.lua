PauseState = Class {__includes = BaseState}

function PauseState:init()
    self.image = love.graphics.newImage("res/graphics/pause-icon.png")
end

function PauseState:enter(params)
    self.timer = params.timer
    self.interval = params.interval
    self.score = params.score
    self.bird = params.bird
    self.y = params.y
    self.pipePairs = params.pipePairs

    sounds["soundtrack"]:pause()
end

function PauseState:update(dt)
    if love.keyboard.waspressed("p") or love.keyboard.waspressed("P") or love.mouse.waspressed(2) then
        gStateMachine:change(
            "play",
            {
                timer = self.timer,
                interval = self.interval,
                score = self.score,
                bird = self.bird,
                y = self.y,
                pipePairs = self.pipePairs
            }
        )
    end
end

function PauseState:render()
    love.graphics.setFont(font_big)
    love.graphics.printf("Take a breather", 0, VIRTUAL_HEIGHT / 2 - font_big:getHeight(), VIRTUAL_WIDTH, "center")

    love.graphics.setFont(font_normal)
    love.graphics.printf('Press "p" to resume playing', 0, VIRTUAL_HEIGHT / 2 + 12, VIRTUAL_WIDTH, "center")

    love.graphics.draw(
        self.image,
        VIRTUAL_WIDTH / 2 - self.image:getWidth() / 2,
        VIRTUAL_HEIGHT / 2 + 12 + 12 + font_normal:getHeight()
    )
end
