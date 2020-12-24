GameLevel = Class {}

function GameLevel:init(def)
  self.objects = def.objects
  self.tileMap = def.tileMap
end

function GameLevel:render()
  self.tileMap:render()

  for k, object in pairs(self.objects) do
    object:render()
  end
end
