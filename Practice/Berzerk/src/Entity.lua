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

    self.quads = def.quads
    self.stateMachine = def.stateMachine

    if def.currentAnimation then
        self.currentAnimation = def.currentAnimation
    end
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end
