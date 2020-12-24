Creature = Class({__includes = Entity})

function Creature:init(def)
  Entity.init(self, def)
  self.type = def.type

  self.currentAnimation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )
end

function Creature:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.type][self.currentAnimation:getCurrentFrame()],
    self.direction == "left" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "left" and 1 or -1,
    1
  )
end
