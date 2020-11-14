Terrain = {}
Terrain.__index = Terrain

function Terrain:new(world)
  local body = love.physics.newBody(world, 0, WINDOW_HEIGHT)
  body:setUserData("Terrain")

  local points = getTerrainPoints()
  table.insert(points, WINDOW_WIDTH)
  table.insert(points, 0)
  table.insert(points, 0)
  table.insert(points, 0)

  local shape = love.physics.newChainShape(false, points)
  local fixture = love.physics.newFixture(body, shape)

  this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Terrain:render()
  love.graphics.setLineWidth(1)
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end
