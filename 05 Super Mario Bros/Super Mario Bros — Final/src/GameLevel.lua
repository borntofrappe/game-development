GameLevel = Class {}

function GameLevel:init(def)
  self.objects = def.objects
  self.tileMap = def.tileMap
  self.entities = def.entities
end

function GameLevel:update(dt)
  for k, entity in pairs(self.entities) do
    entity:update(dt)
  end
end

function GameLevel:render()
  self.tileMap:render()

  for k, object in pairs(self.objects) do
    object:render()
  end

  for k, entity in pairs(self.entities) do
    entity:render()
  end
end
