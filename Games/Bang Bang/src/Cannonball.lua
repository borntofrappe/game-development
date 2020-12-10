Cannonball = {}
Cannonball.__index = Cannonball

function Cannonball:create()
  this = {}

  setmetatable(this, self)

  return this
end

function Cannonball:render()
end
