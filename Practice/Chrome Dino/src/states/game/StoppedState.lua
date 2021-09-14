StoppedState = BaseState:new()

local KEY_DELAY = 0.1

function StoppedState:enter(params)
    gSounds["jump"]:stop()
    gSounds["stop"]:play()

    self.ground = params.ground
    self.dino = params.dino
    self.dino:changeState("stop")

    self.score = params.score
    if self.score.current > self.score.hiscore then
        self.score.hiscore = self.score.current

        local sep = FILE_PATH:find("/")
        local folder = FILE_PATH:sub(1, sep - 1)
        local file = FILE_PATH:sub(sep + 1)

        love.filesystem.setIdentity(folder)
        love.filesystem.write(file, self.score.hiscore)
    end

    self.collidables = params.collidables
    self.cloud = params.cloud

    self.isListening = false
    Timer:after(
        KEY_DELAY,
        function()
            self.isListening = true
        end
    )
end

function StoppedState:update(dt)
    Timer:update(dt)

    if love.keyboard.waspressed("escape") then
        if self.isListening then
            gStateMachine:change("wait")
            gNight = false
        end
    end

    if love.keyboard.waspressed("space") or love.keyboard.waspressed("up") then
        if self.isListening then
            local ground = Ground:new()
            local dino = Dino:new(ground, "run")
            gNight = false

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
