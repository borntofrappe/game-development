Score = {}

function Score:new()
    local x = VIRTUAL_WIDTH - 1 - gFont:getWidth("HI 9999 9999")
    local y = 1

    love.filesystem.setIdentity("chrome-dino")
    if not love.filesystem.getInfo(FILE_PATH) then
        local highscore = 0
        love.filesystem.write(FILE_PATH, highscore)
    end

    local highscore
    for line in love.filesystem.lines(FILE_PATH) do
        highscore = math.floor(line)
        break
    end

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["hi"] = highscore,
        ["current"] = 0
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Score:render()
    love.graphics.setColor(0.42, 0.42, 0.42)
    love.graphics.print(string.format("HI %04d %04d", self.hi, self.current), self.x, self.y)
end
