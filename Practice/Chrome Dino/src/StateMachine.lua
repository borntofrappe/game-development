StateMachine = {}

function StateMachine:new(states)
    local this = {
        ["empty"] = {
            ["enter"] = function()
            end,
            ["exit"] = function()
            end,
            ["update"] = function()
            end,
            ["render"] = function()
            end
        },
        ["states"] = states or {}
    }

    this.current = this.empty

    self.__index = self
    setmetatable(this, self)

    return this
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName], "Invalid state name: " .. stateName)

    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
