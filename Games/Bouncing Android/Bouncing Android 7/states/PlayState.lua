PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.buildings = {
    {
      image = love.graphics.newImage('res/graphics/buildings-3.png'),
      offset = 0,
      speed = 5
    },
    {
      image = love.graphics.newImage('res/graphics/buildings-2.png'),
      offset = 0,
      speed = 15
    },
    {
      image = love.graphics.newImage('res/graphics/buildings-1.png'),
      offset = 0,
      speed = 30
    }
  }
  self.moon = love.graphics.newImage('res/graphics/moon.png')
  self.backgroundWidth = self.buildings[1].image:getWidth()

  self.android = Android(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  self.lollipops = {
    love.graphics.newImage('res/graphics/lollipop-1.png'),
    love.graphics.newImage('res/graphics/lollipop-2.png'),
    love.graphics.newImage('res/graphics/lollipop-3.png'),
    love.graphics.newImage('res/graphics/lollipop-4.png')
  }
  self.lollipopPairs = {LollipopPair(self.lollipops[math.random(#self.lollipops)])}
  self.timer = 0
  self.interval = 4
end

function PlayState:update(dt)
  for k, building in pairs(self.buildings) do
    building.offset = building.offset + building.speed * dt % self.backgroundWidth
  end

  self.timer = self.timer + dt
  if self.timer > self.interval then
    self.timer = self.timer % self.interval
    self.interval = math.random(3, 5)
    table.insert(self.lollipopPairs, LollipopPair(self.lollipops[math.random(#self.lollipops)]))
  end

  self.android:update(dt)
  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:update(dt)
    if lollipopPair.remove then
      table.remove(self.lollipopPairs, k)
    end
  end  
end

function PlayState:render()
  for k, building in pairs(self.buildings) do
    love.graphics.draw(building.image, -building.offset, 20)
  end
  love.graphics.draw(self.moon, 50, 325)

  self.android:render()
  for k, lollipopPair in pairs(self.lollipopPairs) do
    lollipopPair:render()
  end  
end