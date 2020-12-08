BaseState = {}

function BaseState:create()
  this = {}
  setmetatable(this, self)
  self.__index = self
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
