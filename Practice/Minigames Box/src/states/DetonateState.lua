DetonateState = BaseState:new()

local TARGET_SIZE = {30, 50}
local TARGET_SIZES = 3

local FIREWORK_SIZE = 5

local GRAVITY = 200
local IMPULSE = 35

local PARTICLES = 12
local PARTICLE_LEVELS = 3
local PARTICLE_IMPULSE = 3
local PARTICLE_PUSH = 9

function DetonateState:enter()
    self.progressBar = ProgressBar:new()

    local world = love.physics.newWorld(0, GRAVITY)

    local size = love.math.random(TARGET_SIZES)
    local targetSize = TARGET_SIZE[1] + (TARGET_SIZE[2] - TARGET_SIZE[1]) / (TARGET_SIZES - 1) * (size - 1)

    local target = {
        ["x"] = PLAYING_WIDTH / 2,
        ["y"] = PLAYING_HEIGHT / 3,
        ["size"] = targetSize,
        ["inFocus"] = false,
        ["inPlay"] = true
    }

    target.body = love.physics.newBody(world, target.x, target.y)
    target.shape = love.physics.newRectangleShape(target.size, target.size)
    target.fixture = love.physics.newFixture(target.body, target.shape)

    target.fixture:setSensor(true)
    target.fixture:setUserData("target")

    self.target = target

    local firework = {
        ["x"] = PLAYING_WIDTH / 2,
        ["y"] = PLAYING_HEIGHT - PROGRESS_BAR_HEIGHT / 2,
        ["size"] = FIREWORK_SIZE,
        ["inPlay"] = true
    }

    firework.body = love.physics.newBody(world, firework.x, firework.y, "dynamic")
    firework.shape = love.physics.newCircleShape(firework.size)
    firework.fixture = love.physics.newFixture(firework.body, firework.shape)

    firework.fixture:setSensor(true)
    firework.fixture:setUserData("firework")

    self.firework = firework
    self.firework.body:applyLinearImpulse(0, -IMPULSE)

    local groundHeight = WINDOW_PADDING
    local groundWidth = PLAYING_WIDTH
    local ground = {
        ["x"] = groundWidth / 2,
        ["y"] = PLAYING_HEIGHT + groundHeight / 2,
        ["width"] = groundWidth,
        ["height"] = groundHeight
    }

    ground.body = love.physics.newBody(world, ground.x, ground.y)
    ground.shape = love.physics.newRectangleShape(ground.width, ground.height)
    ground.fixture = love.physics.newFixture(ground.body, ground.shape)

    ground.fixture:setSensor(true)
    ground.fixture:setUserData("ground")

    self.ground = ground

    self.particles = {}

    world:setCallbacks(
        function(fixture1, fixture2)
            local userData = {}
            userData[fixture1:getUserData()] = true
            userData[fixture2:getUserData()] = true

            if userData["firework"] and userData["target"] then
                self.target.inFocus = true
            end

            if userData["firework"] and userData["ground"] then
                local _, vy = self.firework.body:getLinearVelocity()
                if vy > 0 then
                    self.firework.inPlay = false
                    world:setCallbacks()
                end
            end
        end,
        function(fixture1, fixture2)
            local userData = {}
            userData[fixture1:getUserData()] = true
            userData[fixture2:getUserData()] = true

            if userData["firework"] and userData["target"] then
                self.target.inFocus = false
            end
        end
    )

    self.world = world

    self.stencil = 0
end

function DetonateState:update(dt)
    self.progressBar:update(dt)

    if self.progressBar.value == 0 then
        gStateMachine:change(
            "feedback",
            {
                ["hasWon"] = self.target.inFocus
            }
        )
    end

    self.world:update(dt)

    if not self.firework.inPlay then
        if not self.firework.body:isDestroyed() then
            self.firework.body:destroy()

            self.target.inPlay = false
            self.target.body:destroy()
        end

        for k, particle in pairs(self.particles) do
            particle.shape:setRadius(math.max(0, particle.shape:getRadius() - particle.dsize * dt))

            if particle.shape:getRadius() == 0 then
                particle.body:destroy()
                table.remove(self.particles, k)
            end
        end
    end

    if love.mouse.waspressed(1) and self.firework.inPlay then
        self.firework.inPlay = false
        self.world:setCallbacks()

        local particles = {}

        if self.target.inFocus then
            for level = 1, PARTICLE_LEVELS do
                for i = 1, PARTICLES do
                    local angle = math.pi * 2 / PARTICLES * i
                    local dx = math.cos(angle) * PARTICLE_IMPULSE * level
                    local dy = math.sin(angle) * PARTICLE_IMPULSE * level - PARTICLE_PUSH

                    local particle = {
                        ["x"] = self.firework.body:getX(),
                        ["y"] = self.firework.body:getY(),
                        ["size"] = self.firework.shape:getRadius(),
                        ["dx"] = dx,
                        ["dy"] = dy,
                        ["dsize"] = 2
                    }
                    table.insert(particles, particle)
                end
            end
        else
            for i = 1, PARTICLES do
                local particle = {
                    ["x"] = self.firework.body:getX(),
                    ["y"] = self.firework.body:getY(),
                    ["size"] = self.firework.shape:getRadius() / 2,
                    ["dx"] = love.math.random(-1, 1),
                    ["dy"] = love.math.random(-PARTICLE_IMPULSE, 0),
                    ["dsize"] = 5
                }
                table.insert(particles, particle)
            end
        end

        for k, particle in pairs(particles) do
            particle.body = love.physics.newBody(self.world, particle.x, particle.y, "dynamic")
            particle.shape = love.physics.newCircleShape(particle.size)
            particle.fixture = love.physics.newFixture(particle.body, particle.shape)
            particle.body:applyLinearImpulse(particle.dx, particle.dy)
            particle.fixture:setSensor(true)
        end

        self.particles = particles
    end
end

local function stencilFunction()
    love.graphics.rectangle("fill", 0, 0, PLAYING_WIDTH, PLAYING_HEIGHT)
end

function DetonateState:render()
    self.progressBar:render()

    --[[
        love.graphics.setLineWidth(4)
        love.graphics.polygon("fill", self.ground.body:getWorldPoints(self.ground.shape:getPoints()))
    --]]
    love.graphics.stencil(stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    if self.target.inPlay then
        if self.target.inFocus then
            love.graphics.setColor(0.737, 0.204, 0.224)
        else
            love.graphics.setColor(0.17, 0.17, 0.17)
        end
        love.graphics.setLineWidth(4)
        love.graphics.polygon("line", self.target.body:getWorldPoints(self.target.shape:getPoints()))
    end

    if self.firework.inPlay then
        love.graphics.setColor(0.737, 0.204, 0.224)
        love.graphics.circle(
            "fill",
            self.firework.body:getX(),
            self.firework.body:getY(),
            self.firework.shape:getRadius()
        )
    else
        love.graphics.setColor(0.737, 0.204, 0.224)
        for k, particle in pairs(self.particles) do
            love.graphics.circle("fill", particle.body:getX(), particle.body:getY(), particle.shape:getRadius())
        end
    end

    love.graphics.setStencilTest()
end
