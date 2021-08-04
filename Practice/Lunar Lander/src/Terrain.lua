Terrain = {}

function Terrain:new(world)
  local body = love.physics.newBody(gWorld, 0, 0)
  local shape = love.physics.newChainShape(false, gTerrain)
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
