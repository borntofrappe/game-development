Entity = {}

function Entity:new()
    local this = {}

    self.__index = self
    setmetatable(this, self)

    return this
end

function Entity:init(def)
    self.x = def.x
    self.y = def.y

    self.dx = 0
    self.dy = 0

    self.size = def.size

    self.direction = def.direction
    self.quads = def.quads
    self.stateMachine = def.stateMachine
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:render()
    love.graphics.draw(
        gTexture,
        gQuads[self.quads][self.currentAnimation:getCurrentFrame()],
        self.direction == "right" and math.floor(self.x) or math.floor(self.x) + self.size,
        math.floor(self.y),
        0,
        self.direction == "right" and 1 or -1,
        1
    )
end
