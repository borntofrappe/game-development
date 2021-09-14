PlayingState = BaseState:new()

local SPAWN_INTERVAL = 4

function PlayingState:enter(params)
    self.ground = params.ground
    self.dino = params.dino

    self.clouds = {}
    self.cacti = {}
    self.bird = nil
    self.interval = SPAWN_INTERVAL

    Timer:every(
        self.interval,
        function()
            table.insert(self.cacti, Cactus:new(self.ground))
        end
    )
end

function PlayingState:update(dt)
    if love.keyboard.waspressed("escape") then
        Timer:reset()
        gStateMachine:change("wait")
    end

    Timer:update(dt)

    self.dino:update(dt)

    self.ground.x = self.ground.x - SCROLL_SPEED * dt
    if self.ground.x <= -self.ground.width then
        self.ground.x = 0
    end

    for k, cloud in pairs(self.clouds) do
        cloud:update(dt)
        if not self.cloud.inPlay then
            table.remove(self.clouds, k)
        end
    end

    for k, cactus in pairs(self.cacti) do
        cactus:update(dt)

        if self.dino:collides(cactus) then
            gStateMachine:change(
                "stop",
                {
                    ["dino"] = self.dino,
                    ["ground"] = self.ground,
                    ["clouds"] = self.clouds,
                    ["cacti"] = self.cacti,
                    ["bird"] = self.bird
                }
            )
        end

        if not cactus.inPlay then
            table.remove(self.cacti, k)
        end
    end

    if self.bird then
        self.bird:update(dt)

        if self.dino:collides(self.bird) then
            gStateMachine:change(
                "stop",
                {
                    ["dino"] = self.dino,
                    ["ground"] = self.ground,
                    ["clouds"] = self.clouds,
                    ["cacti"] = self.cacti,
                    ["bird"] = self.bird
                }
            )
        end

        if not self.bird.inPlay then
            self.bird = nil
        end
    end
end

function PlayingState:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self.ground:render()
    self.dino:render()

    for k, cloud in pairs(self.clouds) do
        cloud:render()
    end

    for k, cactus in pairs(self.cacti) do
        cactus:render()
    end

    if self.bird then
        self.bird:render()
    end
end
