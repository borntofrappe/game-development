PlayingState = BaseState:new()

local COLLIDABLE_BUCKETS = {
    {
        ["cactus"] = 1
    },
    {
        ["cactus"] = 3,
        ["cacti"] = 1
    },
    {
        ["cactus"] = 5,
        ["cacti"] = 3,
        ["bird"] = 1
    },
    {
        ["cactus"] = 8,
        ["cacti"] = 4,
        ["bird"] = 2
    },
    {
        ["cactus"] = 10,
        ["cacti"] = 6,
        ["bird"] = 3
    }
}

function PlayingState:enter(params)
    self.ground = params.ground
    self.dino = params.dino
    self.score = params.score

    self.scrollSpeed = SCROLL_SPEED.min

    self.cloud = Cloud:new(self.scrollSpeed)

    local collidablesBuckets = {}
    for i, collidableBucket in ipairs(COLLIDABLE_BUCKETS) do
        local bucket = {}
        for k, odds in pairs(collidableBucket) do
            for odd = 1, odds do
                table.insert(bucket, k)
            end
        end

        table.insert(collidablesBuckets, bucket)
    end

    self.collidablesBuckets = collidablesBuckets
    self.scrollSpeedThreshold = math.ceil(SCROLL_SPEED.max - SCROLL_SPEED.min) / #self.collidablesBuckets

    self.collidables = self:addCollidables()
end

function PlayingState:addCollidables()
    local scrollSpeedIndex =
        math.min(
        #self.collidablesBuckets,
        math.floor((self.scrollSpeed - SCROLL_SPEED.min) / self.scrollSpeedThreshold) + 1
    )
    local bucket = self.collidablesBuckets[scrollSpeedIndex]
    local collidable = bucket[love.math.random(#bucket)]

    if collidable == "bird" then
        return {Bird:new(self.ground, self.scrollSpeed)}
    elseif collidable == "cacti" then
        local cacti = {}
        local offset = 0
        for i = 1, 2 do
            local type = love.math.random(#CACTI)
            local width = CACTI[type].width
            table.insert(cacti, Cactus:new(self.ground, self.scrollSpeed, type, offset))
            offset = offset + width + 1
        end

        return cacti
    else
        return {Cactus:new(self.ground, self.scrollSpeed)}
    end
end

function PlayingState:update(dt)
    self.score.current = self.score.current + SCORE_SPEED * dt

    if love.keyboard.waspressed("escape") then
        gStateMachine:change("wait")
    end

    self.scrollSpeed = math.min(SCROLL_SPEED.max, self.scrollSpeed + dt)

    self.dino:update(dt)

    self.ground.x = self.ground.x - self.scrollSpeed * dt
    if self.ground.x <= -self.ground.width then
        self.ground.x = 0
    end

    for k, collidable in pairs(self.collidables) do
        collidable:update(dt)

        if self.dino:collides(collidable) then
            gStateMachine:change(
                "stop",
                {
                    ["dino"] = self.dino,
                    ["ground"] = self.ground,
                    ["score"] = self.score,
                    ["cloud"] = self.cloud,
                    ["collidables"] = self.collidables
                }
            )
        end

        if not collidable.inPlay then
            table.remove(self.collidables, k)

            if #self.collidables == 0 then
                self.collidables = self:addCollidables()
            end
        end
    end

    if self.cloud then
        self.cloud:update(dt)

        if not self.cloud.inPlay then
            self.cloud = Cloud:new(self.scrollSpeed)
        end
    end
end

function PlayingState:render()
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
