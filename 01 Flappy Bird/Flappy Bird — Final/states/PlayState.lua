PlayState = Class {__includes = BaseState}

function PlayState:init()
    self.bird = Bird()

    self.y = math.random(THRESHOLD_UPPER, THRESHOLD_LOWER)
    self.pipePairs = {PipePair(self.y)}

    self.timer = 0
    self.interval = 3.5

    self.score = 0
end

function PlayState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.interval then
        self.timer = self.timer % self.interval

        local following_y = self.y + math.random(Y_CHANGE, Y_CHANGE * -1)
        self.y = math.min(THRESHOLD_LOWER, math.max(following_y, THRESHOLD_UPPER))
        table.insert(self.pipePairs, PipePair(self.y))
    end

    self.bird:update(dt)

    for k, pipePair in pairs(self.pipePairs) do
        pipePair:update(dt)

        for l, pipe in pairs(pipePair.pipes) do
            if self.bird:collides(pipe) then
                sounds["lose"]:play()
                sounds["hit"]:play()

                gStateMachine:change(
                    "score",
                    {
                        score = self.score
                    }
                )
            end
        end

        if pipePair.remove then
            table.remove(self.pipePairs, k)
        end

        if not pipePair.scored and self.bird.x > pipePair.x + pipePair.width then
            pipePair.scored = true
            self.score = self.score + 1

            sounds["score"]:play()
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 16 then
        sounds["lose"]:play()
        gStateMachine:change(
            "score",
            {
                score = self.score
            }
        )
    end
end

function PlayState:render()
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:render()
    end

    self.bird:render()

    love.graphics.setFont(font_normal)
    love.graphics.print("Score: " .. self.score, 8, 8)
end
