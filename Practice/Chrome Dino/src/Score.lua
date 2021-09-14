Score = {}

local PADDING = 1

function Score:new()
    local x = VIRTUAL_WIDTH - PADDING - gFont:getWidth("HI " .. SCORE_MAX .. " " .. SCORE_MAX)
    local y = PADDING

    local sep = FILE_PATH:find("/")
    local folder = FILE_PATH:sub(1, sep - 1)
    local file = FILE_PATH:sub(sep + 1)

    love.filesystem.setIdentity(folder)
    if not love.filesystem.getInfo(file) then
        local highscore = 0
        love.filesystem.write(file, highscore)
    end

    local highscore
    for line in love.filesystem.lines(file) do
        highscore = math.floor(line)
        break
    end

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["hiscore"] = highscore,
        ["current"] = 0
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Score:render()
    love.graphics.setColor(0.42, 0.42, 0.42)
    love.graphics.print(string.format("HI %04d %04d", self.hiscore, self.current), self.x, self.y)
end
