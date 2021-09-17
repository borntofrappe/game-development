ProgressBar = {}

function ProgressBar:new()
    local progress = PROGRESS_BAR_DELAY
    local height = PROGRESS_BAR_HEIGHT

    local this = {
        ["width"] = PLAYING_WIDTH,
        ["height"] = PROGRESS_BAR_HEIGHT,
        ["x"] = 0,
        ["y"] = PLAYING_HEIGHT - height,
        ["value"] = progress,
        ["max"] = progress
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function ProgressBar:update(dt)
    self.value = math.max(0, self.value - dt)
end

function ProgressBar:render()
    love.graphics.setColor(0.17, 0.17, 0.17)
    love.graphics.rectangle("fill", self.x, self.y, self.width / self.max * self.value, self.height)
end
