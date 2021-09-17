DetonateState = BaseState:new()

local TARGET_SIZE = {20, 30}
local TARGET_SIZES = 3

local FIREWORK_SIZE = 5

local PARTICLES = 12

function DetonateState:enter()
    self.progressBar = ProgressBar:new()

    local size = love.math.random(TARGET_SIZES)
    local targetSize = TARGET_SIZE[1] + (TARGET_SIZE[2] - TARGET_SIZE[1]) / (TARGET_SIZES - 1) * (size - 1)
    self.target = {
        ["x"] = PLAYING_WIDTH / 2 - targetSize / 2,
        ["y"] = PLAYING_HEIGHT / 3 - targetSize / 2,
        ["size"] = targetSize,
        ["inFocus"] = false,
        ["inPlay"] = true
    }

    self.firework = {
        ["x"] = PLAYING_WIDTH / 2,
        ["y"] = PLAYING_HEIGHT - PROGRESS_BAR_HEIGHT / 2,
        ["size"] = FIREWORK_SIZE,
        ["inPlay"] = true
    }

    self.particles = {}
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

    self.target.inFocus = self.firework.y > self.target.y and self.firework.y < self.target.y + self.target.size

    if self.firework.inPlay then
        self.firework.y = self.firework.y - 100 * dt

        if self.firework.y < self.firework.size then
            self.firework.inPlay = false
        end
    else
        for k, particle in pairs(self.particles) do
            particle.x = particle.x + particle.dx * dt
            particle.y = particle.y + particle.dy * dt
            particle.dy = particle.dy + dt
            particle.size = math.max(0, particle.size - particle.dsize * dt)

            if
                particle.size == 0 or particle.x < particle.size or particle.x > PLAYING_WIDTH - particle.size or
                    particle.y < 0 or
                    particle.y > PLAYING_HEIGHT - particle.size
             then
                table.remove(self.particles, k)
            end
        end
    end

    if love.mouse.waspressed(1) and self.firework.inPlay then
        self.firework.inPlay = false
        self.target.inPlay = false

        local particles = {}

        if self.target.inFocus then
            for level = 1, 3 do
                for i = 1, PARTICLES do
                    local angle = math.pi * 2 / PARTICLES * i
                    local dx = math.cos(angle) * (20 * level)
                    local dy = math.sin(angle) * (20 * level)

                    local particle = {
                        ["x"] = self.firework.x,
                        ["y"] = self.firework.y,
                        ["size"] = self.firework.size,
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
                    ["x"] = self.firework.x,
                    ["y"] = self.firework.y,
                    ["size"] = self.firework.size / 2,
                    ["dx"] = love.math.random(-15, 15),
                    ["dy"] = love.math.random(-15, 15),
                    ["dsize"] = 2
                }
                table.insert(particles, particle)
            end
        end

        self.particles = particles
    end
end

function DetonateState:render()
    self.progressBar:render()

    if self.target.inPlay then
        if self.target.inFocus then
            love.graphics.setColor(0.737, 0.204, 0.224)
        else
            love.graphics.setColor(0.17, 0.17, 0.17)
        end
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", self.target.x, self.target.y, self.target.size, self.target.size)
    end

    if self.firework.inPlay then
        love.graphics.setColor(0.737, 0.204, 0.224)
        love.graphics.circle("fill", self.firework.x, self.firework.y, self.firework.size)
    else
        love.graphics.setColor(0.737, 0.204, 0.224)
        for k, particle in pairs(self.particles) do
            love.graphics.circle("fill", particle.x, particle.y, particle.size)
        end
    end
end
