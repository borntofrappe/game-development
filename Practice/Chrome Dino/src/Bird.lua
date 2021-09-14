Bird = {}

local INTERVAL_ANIMATION = 0.12

function Bird:new(ground, scrollSpeed, frame)
    local frame = frame or 1
    local width = BIRD[frame].width
    local height = BIRD[frame].height

    local x = VIRTUAL_WIDTH
    local y = love.math.random(math.floor(VIRTUAL_HEIGHT / 2), VIRTUAL_HEIGHT - height - ground.height)

    local hitRadius = ((width ^ 2 + height ^ 2) ^ 0.5) / 3.5

    local dx = math.floor(scrollSpeed * 1.25)

    local frames = {}
    for i = 1, #gQuads["bird"] do
        table.insert(frames, i)
    end

    local animation = Animation:new(frames, INTERVAL_ANIMATION)

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["hitRadius"] = hitRadius,
        ["dx"] = dx,
        ["animation"] = animation,
        ["inPlay"] = true
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Bird:update(dt)
    if self.inPlay then
        self.animation:update(dt)

        self.x = self.x - self.dx * dt
        if self.x < -self.width then
            self.inPlay = false
        end
    end
end

function Bird:render()
    if self.inPlay then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            gTextures["spritesheet"],
            gQuads["bird"][self.animation:getCurrentFrame()],
            math.floor(self.x),
            math.floor(self.y)
        )

    --[[
        love.graphics.setColor(0, 1, 0, 0.5)
        love.graphics.circle("fill", self.x + self.width / 2, self.y + self.height / 2, self.hitRadius)
    --]]
    end
end
