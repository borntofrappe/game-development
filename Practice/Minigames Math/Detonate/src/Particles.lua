Particles = {}

local GRAVITY = 1
local FIZZLE_SPEED = {
    ["r"] = 5,
    ["coor"] = 0.1
}

local EXPLODE_SPEED = {
    ["r"] = 1.5,
    ["coor"] = 0.5
}

function Particles:new()
    local r = PARTICLE_RADIUS
    local particles = {}

    local this = {
        ["particles"] = particles,
        ["r"] = r
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Particles:explode(firework)
    local x = firework.x
    local y = firework.y
    local r = self.r

    local particles = {}
    for i = 1, 10 do
        local angle = math.pi * 2 * i / 10
        local dx = math.cos(angle) * EXPLODE_SPEED.coor
        local dy = math.sin(angle) * EXPLODE_SPEED.coor - EXPLODE_SPEED.coor
        local dr = EXPLODE_SPEED.r
        table.insert(
            particles,
            {
                ["r"] = r,
                ["x"] = x,
                ["y"] = y,
                ["dx"] = dx,
                ["dy"] = dy,
                ["dr"] = dr
            }
        )
    end

    self.particles = particles
end

function Particles:fizzle(firework)
    local x = firework.x
    local y = firework.y
    local r = self.r

    local particles = {}
    for i = 1, 5 do
        local dx = love.math.random(-1, 1) * FIZZLE_SPEED.coor
        local dy = love.math.random(-1, 1) * FIZZLE_SPEED.coor
        local dr = FIZZLE_SPEED.r
        table.insert(
            particles,
            {
                ["r"] = r,
                ["x"] = x,
                ["y"] = y,
                ["dx"] = dx,
                ["dy"] = dy,
                ["dr"] = dr
            }
        )
    end

    self.particles = particles
end

function Particles:update(dt)
    for k, particle in pairs(self.particles) do
        particle.x = particle.x + particle.dx
        particle.y = particle.y + particle.dy
        particle.dy = particle.dy + GRAVITY * dt

        particle.r = math.max(0, particle.r - particle.dr * dt)

        if particle.r == 0 then
            table.remove(self.particles, k)
        end
    end
end

function Particles:render()
    love.graphics.setColor(0.94, 0.25, 0.72)
    for k, particle in pairs(self.particles) do
        love.graphics.circle("fill", particle.x, particle.y, particle.r)
    end
end
