Message = {}

function Message:new(y, text)
    local this = {
        ["y"] = y,
        ["text"] = text,
        ["index"] = 0
    }

    local label = "message" .. #Timer.intervals

    Timer:every(
        0.125,
        function()
            this.index = this.index + 1
            if this.index == #this.text then
                Timer:remove(label)
            end
        end,
        false,
        label
    )

    self.__index = self
    setmetatable(this, self)

    return this
end

function Message:render()
    love.graphics.setColor(0.824, 0.824, 0.824)
    love.graphics.setFont(gFonts.normal)
    love.graphics.printf(self.text:sub(0, self.index), 0, self.y, VIRTUAL_WIDTH, "center")
end
