Creature = Class({__includes = Entity})

function Creature:init(def)
  Entity.init(self, def)
  self.type = def.type
end

function Creature:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.type][1],
    self.direction == "right" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
