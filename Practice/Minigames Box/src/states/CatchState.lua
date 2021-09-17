CatchState = BaseState:new()

local GRAVITY = 200
local BALL_LINEAR_VELOCITY = {
    ["x"] = {-100, 100},
    ["y"] = -100
}

function CatchState:enter()
    self.timer = COUNTDOWN_LEVEL

    local world = love.physics.newWorld(0, GRAVITY)

    local mouseX = love.mouse:getPosition()
    local xStart = PLAYING_WIDTH / 2
    if mouseX > WINDOW_PADDING and mouseX < WINDOW_PADDING + PLAYING_WIDTH then
        xStart = mouseX
    end
    local container = {
        ["xStart"] = xStart,
        ["yStart"] = PLAYING_HEIGHT * 3 / 4,
        ["size"] = 50,
        ["points"] = {},
        ["lineWidth"] = 8
    }
    container.flap = container.lineWidth / 2

    local n = 20
    for i = 0, n - 1 do
        local angle = math.rad(180 - i * 180 / n)
        local x = math.cos(angle) * container.size
        local y = math.sin(angle) * container.size

        table.insert(container.points, x)
        table.insert(container.points, y)
    end

    for i = 0, n - 1 do
        local angle = math.rad(180 + i * 180 / n)
        local x = container.size + container.flap + math.cos(angle) * container.flap
        local y = math.sin(angle) * container.flap

        table.insert(container.points, x)
        table.insert(container.points, y)
    end

    for i = 0, n - 1 do
        local angle = math.rad(i * 180 / n)
        local x = math.cos(angle) * (container.size + container.flap * 2)
        local y = math.sin(angle) * (container.size + container.flap * 2)

        table.insert(container.points, x)
        table.insert(container.points, y)
    end

    for i = 0, n - 1 do
        local angle = math.rad(180 + i * 180 / n)
        local x = -(container.size + container.flap) + math.cos(angle) * container.flap
        local y = math.sin(angle) * container.flap

        table.insert(container.points, x)
        table.insert(container.points, y)
    end

    container.body = love.physics.newBody(world, container.xStart, container.yStart, "kinematic")
    container.shape = love.physics.newChainShape(true, container.points)
    container.fixture = love.physics.newFixture(container.body, container.shape)
    container.fixture:setFriction(0)

    self.container = container

    local r = math.random(12, 20)
    local ball = {
        ["x"] = math.random(r, PLAYING_WIDTH - r),
        ["y"] = math.random(r, math.floor(PLAYING_HEIGHT / 2 - r)),
        ["r"] = r
    }

    ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
    ball.shape = love.physics.newCircleShape(ball.r)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape)
    ball.fixture:setRestitution(0.5)
    ball.body:setLinearVelocity(
        math.random(BALL_LINEAR_VELOCITY.x[1], BALL_LINEAR_VELOCITY.x[2]),
        BALL_LINEAR_VELOCITY.y
    )

    self.ball = ball

    local walls = {}
    walls.body = love.physics.newBody(world, 0, 0)
    walls.shape =
        love.physics.newChainShape(true, 0, 0, PLAYING_WIDTH, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 0, PLAYING_HEIGHT)
    walls.fixture = love.physics.newFixture(walls.body, walls.shape)

    self.walls = walls

    self.world = world
end

function CatchState:update(dt)
    self.timer = math.max(0, self.timer - dt)

    if self.timer == 0 then
        local ball = {
            ["x"] = self.ball.body:getX(),
            ["y"] = self.ball.body:getY(),
            ["r"] = self.ball.shape:getRadius()
        }

        local container = {
            ["x"] = self.container.body:getX(),
            ["y"] = self.container.body:getY(),
            ["r"] = self.container.size
        }

        local hasWon =
            ball.y > container.y - ball.r and ball.y < container.y + container.r and ball.x > container.x - container.r and
            ball.x < container.x + container.r

        gStateMachine:change(
            "feedback",
            {
                ["hasWon"] = hasWon
            }
        )
    end

    self.world:update(dt)

    local x, y = love.mouse:getPosition()
    if
        x > WINDOW_PADDING and x < WINDOW_WIDTH - WINDOW_PADDING and y > WINDOW_PADDING and
            y < WINDOW_HEIGHT - WINDOW_PADDING
     then
        self.container.xStart =
            math.max(
            self.container.size + self.container.flap + self.container.lineWidth,
            math.min(PLAYING_WIDTH - self.container.size - self.container.flap - self.container.lineWidth, x)
        )
        self.container.body:setX(self.container.xStart)
    end
end

function CatchState:render()
    love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.rectangle(
        "fill",
        0,
        PLAYING_HEIGHT - COUNTDOWN_LEVEL_BAR_HEIGHT,
        PLAYING_WIDTH * self.timer / COUNTDOWN_LEVEL,
        COUNTDOWN_LEVEL_BAR_HEIGHT
    )

    love.graphics.setColor(0.737, 0.204, 0.224)
    love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())
    love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

    -- love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.setLineWidth(self.container.lineWidth)
    love.graphics.line(self.container.body:getWorldPoints(self.container.shape:getPoints()))
end
