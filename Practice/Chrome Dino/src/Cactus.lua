Cactus = {}

local CACTUS_INSET = {
    ["y"] = 3
}

function Cactus:new(ground, scrollSpeed, type, offset)
    local type = type or love.math.random(#CACTI)
    local offset = offset or 0

    local width = CACTI[type].width
    local height = CACTI[type].height

    local x = ground.x + ground.width + VIRTUAL_WIDTH + offset
    local y = ground.y - height + CACTUS_INSET.y

    local dx = scrollSpeed

    local hitRadius = ((width ^ 2 + height ^ 2) ^ 0.5) / 3

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["hitRadius"] = hitRadius,
        ["type"] = type,
        ["dx"] = dx,
        ["inPlay"] = true
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Cactus:update(dt)
    if self.inPlay then
        self.x = self.x - self.dx * dt
        if self.x < -self.width then
            self.inPlay = false
        end
    end
end

function Cactus:render()
    if self.inPlay then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(gTextures["spritesheet"], gQuads["cacti"][self.type], math.floor(self.x), math.floor(self.y))

    --[[
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.circle("fill", self.x + self.width / 2, self.y + self.height / 2, self.hitRadius)
    --]]
    end
end
