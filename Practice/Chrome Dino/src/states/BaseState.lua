BaseState = {}

function BaseState:new()
    local this = {}

    self.__index = self
    setmetatable(this, self)

    return this
end

function BaseState:enter()
end

function BaseState:exit()
end

function BaseState:update(dt)
end

function BaseState:render()
end
