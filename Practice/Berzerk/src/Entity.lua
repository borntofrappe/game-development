Entity = {}

local ENTITY_DEFAULT_INSET = 1
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

    self.level = def.level
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:collides(target, inset)
    local inset = inset or ENTITY_DEFAULT_INSET
    if target.x + target.width - inset < self.x or target.x + inset > self.x + self.width then
        return false
    end

    if target.y + target.height - inset < self.y or target.y + inset > self.y + self.height then
        return false
    end

    return true
end
