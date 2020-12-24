StateStack = Class {}

function StateStack:init(states)
  self.states = states or {}
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
