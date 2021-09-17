Target = {}

function Target:new()
    local size = TARGET_SIZE
    local x = WINDOW_WIDTH / 2 - size / 2
    local y = WINDOW_HEIGHT / 3 - size / 2

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["size"] = size,
        ["inFocus"] = false,
        ["inPlay"] = true
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Target:render()
    if self.inPlay then
        love.graphics.setLineWidth(1)
        if self.inFocus then
            love.graphics.setColor(0.94, 0.25, 0.72)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
    end
end
