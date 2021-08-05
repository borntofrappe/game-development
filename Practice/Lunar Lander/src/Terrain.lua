Terrain = {}

function Terrain:new(world, points)
  local body = love.physics.newBody(world, 0, 0)
  local shape = love.physics.newChainShape(false, points)
  local fixture = love.physics.newFixture(body, shape)
  fixture:setUserData("terrain")

  local this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  self.__index = self
  setmetatable(this, self)

  return this
end
