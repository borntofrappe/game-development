Score = {}

function Score:new()
    local x = VIRTUAL_WIDTH - 1 - gFont:getWidth("HI 9999 9999")
    local y = 1
    local this = {
        ["x"] = x,
        ["y"] = y,
        ["record"] = 0,
        ["current"] = 0
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Score:render()
    love.graphics.setColor(0.42, 0.42, 0.42)
    love.graphics.print(string.format("HI %04d %04d", self.record, self.current), self.x, self.y)
end
