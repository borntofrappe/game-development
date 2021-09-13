Dino = {}

function Dino:new(ground, state)
    local state = state or "idle"

    local x = ground.x + 2
    local y = ground.y - DINO_STATES[state].height + math.floor(gTextures["ground"]:getHeight() * 4 / 5)
    local width = DINO_STATES[state].width
    local height = DINO_STATES[state].height

    local frames = {}
    for i = 1, DINO_STATES[state].frames do
        table.insert(frames, i)
    end
    local animation = Animation:new(frames, 0.15)

    local this = {
        ["x"] = x,
        ["y"] = y,
        ["width"] = width,
        ["height"] = height,
        ["state"] = state,
        ["animation"] = animation
    }

    self.__index = self
    setmetatable(this, self)

    return this
end

function Dino:update(dt)
    self.animation:update(dt)
end

function Dino:render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        gTextures["spritesheet"],
        gQuads["dino"][self.state][self.animation:getCurrentFrame()],
        self.x,
        self.y
    )
end
