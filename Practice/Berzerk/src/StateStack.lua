StateStack = {}

function StateStack:new(states)
  local states = states or {}
  for i, state in ipairs(states) do
    state:enter()
  end

  local this = {
    ["states"] = states
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function StateStack:update(dt)
  self.states[#self.states]:update(dt)
end

function StateStack:render()
  for i, state in ipairs(self.states) do
    state:render()
  end
end

function StateStack:push(state)
  table.insert(self.states, state)
  state:enter()
end

function StateStack:pop()
  self.states[#self.states]:exit()
  table.remove(self.states)
end

function StateStack:clear()
  self.states = {}
end
