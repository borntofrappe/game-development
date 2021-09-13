PlayingState = BaseState:new()

local SPAWN_INTERVAL = 4

function PlayingState:enter()
    self.cloud = Cloud:new()

    self.cacti = {}

    Timer:every(
        SPAWN_INTERVAL,
        function()
            table.insert(self.cacti, Cactus:new(gGround))
        end,
        true
    )
end

function PlayingState:update(dt)
    Timer:update(dt)
    gDino:update(dt)

    self.cloud:update(dt)
    if not self.cloud.inPlay then
        self.cloud = Cloud:new()
    end

    for k, cactus in pairs(self.cacti) do
        cactus:update(dt)

        if gDino:collides(cactus) then
            gStateStack:push(StoppedState:new())
        end

        if not cactus.inPlay then
            table.remove(self.cacti, k)
        end
    end

    gGround.x = gGround.x - SCROLL_SPEED * dt
    if gGround.x <= -gGround.width then
        gGround.x = 0
    end

    if love.keyboard.waspressed("escape") then
        Timer:reset()
        gStateStack:pop()
        gStateStack:push(WaitingState:new())
    end
end

function PlayingState:render()
    self.cloud:render()

    for k, cactus in pairs(self.cacti) do
        cactus:render()
    end
end

function PlayingState:exit()
    gDino:changeState("idle")
    gGround.x = 0
end
