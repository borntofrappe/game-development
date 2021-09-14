StoppedState = BaseState:new()

function StoppedState:enter(params)
    self.ground = params.ground
    self.dino = params.dino
    self.dino:changeState("stop")

    self.score = params.score
    if self.score.current > self.score.hi then
        self.score.hi = self.score.current

        love.filesystem.setIdentity("chrome-dino")
        local highscore
        for line in love.filesystem.lines(FILE_PATH) do
            highscore = math.floor(line)
            break
        end

        if self.score.hi > highscore then
            love.filesystem.write(FILE_PATH, self.score.hi)
        end
    end

    self.collidables = params.collidables
    self.cloud = params.cloud
end

function StoppedState:update(dt)
    if love.keyboard.waspressed("escape") or love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        gStateMachine:change("wait")
        gNight = false
    end

    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        local ground = Ground:new()
        local dino = Dino:new(ground, "run")

        self.score.current = 0
        gStateMachine:change(
            "play",
            {
                ["ground"] = ground,
                ["dino"] = dino,
                ["score"] = self.score
            }
        )
    end
end

function StoppedState:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self.ground:render()

    for k, collidable in pairs(self.collidables) do
        collidable:render()
    end

    if self.cloud then
        self.cloud:render()
    end

    self.dino:render()

    self.score:render()
end
