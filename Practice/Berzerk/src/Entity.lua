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

    self.width = def.width
    self.height = def.height

    self.quads = def.quads
    self.stateMachine = def.stateMachine

    self.walls = def.walls

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

function Entity:collides(target)
    if target.x + target.width - 1 < self.x or target.x + 1 > self.x + self.width then
        return false
    end

    if target.y + target.height - 1 < self.y or target.y + 1 > self.y + self.height then
        return false
    end

    return true
end
