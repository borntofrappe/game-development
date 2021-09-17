TiltState = BaseState:new()

local GRAVITY = 500
local ANGLE_SPEED = 2
local ANGLE_INITIAL = 4

function TiltState:enter()
    self.progressBar = ProgressBar:new()
    self.hasWon = false

    local world = love.physics.newWorld(0, GRAVITY)

    local platform = {
        ["width"] = math.random(180, 220),
        ["height"] = 8
    }
    platform.x = PLAYING_WIDTH / 2 - platform.width / 2
    platform.y = PLAYING_HEIGHT / 3 - platform.height / 2

    platform.body =
        love.physics.newBody(world, platform.x + platform.width / 2, platform.y + platform.height / 2, "kinematic")
    platform.shape = love.physics.newRectangleShape(platform.width, platform.height)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape)
    platform.body:setAngle(math.random(2) == 1 and math.rad(ANGLE_INITIAL * -1) or math.rad(ANGLE_INITIAL))
    platform.fixture:setUserData("platform")

    self.platform = platform

    local ball = {
        ["x"] = PLAYING_WIDTH / 2,
        ["r"] = 15
    }
    ball.y = platform.y - ball.r - 10

    ball.body = love.physics.newBody(world, ball.x, ball.y, "dynamic")
    ball.shape = love.physics.newCircleShape(ball.r)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape)
    ball.body:setSleepingAllowed(false)
    ball.fixture:setRestitution(0.5)
    ball.fixture:setFriction(0.25)
    ball.fixture:setUserData("ball")

    self.ball = ball

    local container = {
        ["lineWidth"] = 8,
        ["width"] = math.random(math.floor(platform.width / 4), math.floor(platform.width / 2)),
        ["height"] = 100
    }

    container.x =
        math.random(2) == 1 and platform.x - container.width / 2 or platform.x + platform.width - container.width / 2
    container.y = PLAYING_HEIGHT - container.height - container.lineWidth / 2

    container.body = love.physics.newBody(world, container.x, container.y)
    container.shape =
        love.physics.newChainShape(
        false,
        0,
        0,
        0,
        container.height,
        container.width,
        container.height,
        container.width,
        0
    )
    container.fixture = love.physics.newFixture(container.body, container.shape)
    container.fixture:setUserData("container")

    self.container = container

    local sensor = {}
    sensor.body =
        love.physics.newBody(world, container.x + container.width / 2, container.y + container.height / 2 + ball.r / 2)
    sensor.shape = love.physics.newRectangleShape(container.width - container.lineWidth, container.height - ball.r)
    sensor.fixture = love.physics.newFixture(sensor.body, sensor.shape)
    sensor.fixture:setSensor(true)
    sensor.fixture:setUserData("sensor")

    self.sensor = sensor

    local walls = {}
    walls.body = love.physics.newBody(world, 0, 0)
    walls.shape =
        love.physics.newChainShape(true, 0, 0, PLAYING_WIDTH, 0, PLAYING_WIDTH, PLAYING_HEIGHT, 0, PLAYING_HEIGHT)
    walls.fixture = love.physics.newFixture(walls.body, walls.shape)
    walls.fixture:setUserData("walls")

    self.walls = walls

    world:setCallbacks(
        function(fixture1, fixture2)
            if self.hasWon then
                return
            end

            local userData = {}
            userData[fixture1:getUserData()] = true
            userData[fixture2:getUserData()] = true

            if userData["ball"] and userData["sensor"] then
                self.hasWon = true
            end
        end
    )

    self.world = world
end

function TiltState:update(dt)
    self.progressBar:update(dt)

    if self.progressBar.value == 0 then
        gStateMachine:change(
            "feedback",
            {
                ["hasWon"] = self.hasWon
            }
        )
    end

    self.world:update(dt)

    if love.mouse.isDown(1) then
        local x = love.mouse:getPosition()
        if x > PLAYING_WIDTH / 2 then
            self.platform.body:setAngle(self.platform.body:getAngle() + ANGLE_SPEED * dt)
        else
            self.platform.body:setAngle(self.platform.body:getAngle() + ANGLE_SPEED * dt * -1)
        end
    end
end

function TiltState:render()
    self.progressBar:render()

    love.graphics.setColor(0.737, 0.204, 0.224)
    love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())
    love.graphics.setLineWidth(4)
    love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.circle("line", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())

    -- love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.polygon("fill", self.platform.body:getWorldPoints(self.platform.shape:getPoints()))

    -- love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.setLineWidth(self.container.lineWidth)
    love.graphics.line(self.container.body:getWorldPoints(self.container.shape:getPoints()))

    -- love.graphics.polygon("fill", self.sensor.body:getWorldPoints(self.sensor.shape:getPoints()))
end
