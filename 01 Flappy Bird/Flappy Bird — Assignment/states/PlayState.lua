PlayState = Class {__includes = BaseState}

function PlayState:init()
    self.timer = 0
    self.interval = math.random(INTERVAL_MIN, INTERVAL_MAX)
    self.score = 0

    self.bird = Bird()
    self.gap = math.random(GAP_MIN, GAP_MAX)
    self.y = math.random(THRESHOLD_UPPER + self.gap, THRESHOLD_LOWER)
    self.pipePairs = {PipePair(self.y, self.gap)}
end

function PlayState:enter(params)
    if params then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.timer = params.timer
        self.interval = params.interval
        self.score = params.score
        self.y = params.y

        sounds["soundtrack"]:play()
    end
end

function PlayState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        self.interval = math.random(INTERVAL_MIN, INTERVAL_MAX)

        self.gap = math.random(GAP_MIN, GAP_MAX)
        local following_y = self.y + math.random(Y_CHANGE, Y_CHANGE * -1)
        self.y = math.min(THRESHOLD_LOWER, math.max(following_y, THRESHOLD_UPPER + self.gap))
        table.insert(self.pipePairs, PipePair(self.y, self.gap))
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
            sounds["score"]:play()
            pipePair.scored = true
            self.score = self.score + 1
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

    if love.keyboard.waspressed("p") or love.keyboard.waspressed("P") then
        sounds["pause"]:play()
        gStateMachine:change(
            "pause",
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

function PlayState:render()
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:render()
    end

    self.bird:render()

    love.graphics.setFont(font_normal)
    love.graphics.print("Score: " .. self.score, 10, 10)
end
