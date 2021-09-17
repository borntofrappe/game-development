Particles = {}

local PARTICLES_FIZZLE = 5
local PARTICLES_DETONATION = {4, 6, 8, 0, 11, 11, 11}

function Particles:new()
    local this = {
        ["particles"] = {}
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Particles:detonate(x, y)
    local color = {["r"] = 0.84, ["g"] = 0, ["b"] = 0.73}
    local r = PARTICLE_RADIUS

    local speedCoordsMin = DETONATION_SPEED.coords[1]
    local speedCoordsMax = DETONATION_SPEED.coords[2]
    local speedCoordsChange = (speedCoordsMax - speedCoordsMin) / #PARTICLES_DETONATION
    local speedRMin = DETONATION_SPEED.r[1]
    local speedRMax = DETONATION_SPEED.r[2]
    local speedRChange = (speedRMax - speedRMin) / #PARTICLES_DETONATION

    local particles = {}
    for i, particlesDetonation in ipairs(PARTICLES_DETONATION) do
        local angleChange = math.pi * 2 / particlesDetonation

        local dr = speedRMin + speedRChange
        local speedCoords = speedCoordsMin + speedCoordsChange * i

        for j = 1, particlesDetonation do
            local angle = angleChange * j
            local dx = math.cos(angle) * speedCoords
            local dy = math.sin(angle) * speedCoords

            local particle = Particle:new(x, y, r, dx, dy, dr, color, ddy)
            table.insert(particles, particle)
        end
    end

    self.particles = particles
end

function Particles:fizzle(x, y)
    local particles = {}

    local color = {["r"] = 1, ["g"] = 1, ["b"] = 1}
    local r = PARTICLE_RADIUS

    for i = 1, PARTICLES_FIZZLE do
        local dx = love.math.random(-1, 1) * FIZZLE_SPEED.coords
        local dy = love.math.random(-1, 1) * FIZZLE_SPEED.coords
        local dr = FIZZLE_SPEED.r
        local particle = Particle:new(x, y, r, dx, dy, dr, color)
        table.insert(particles, particle)
    end

    self.particles = particles
end

function Particles:update(dt)
    for k, particle in pairs(self.particles) do
        particle:update(dt)

        if not particle.inPlay then
            table.remove(self.particles, k)
        end
    end
end

function Particles:render()
    for k, particle in pairs(self.particles) do
        particle:render()
    end
end
