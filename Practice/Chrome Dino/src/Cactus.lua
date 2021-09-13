Cactus = {}

local CACTUS_INSET = {
    ["y"] = 3
}

function Cactus:new(ground, type)
    local type = type or 1
    local width = CACTI_TYPES[type].width
    local height = CACTI_TYPES[type].height

    local x = VIRTUAL_WIDTH
    local y = ground.y + CACTUS_INSET.y - height
    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["type"] = type,
        ["dx"] = SCROLL_SPEED,
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
    end
end
