Creature = Class {}

function Creature:init()
  self.type = math.random(2) == 1 and "land" or "sky"
  self.texture = "creatures_" .. self.type
  self.color = math.random(#gQuads[self.texture])

  self.x = VIRTUAL_WIDTH
  self.y = VIRTUAL_HEIGHT - CREATURE_SIZE
  if self.type == "sky" then
    self.y = self.y - math.random(CREATURE_SIZE, math.floor(VIRTUAL_HEIGHT / 2))
  end

  self.width = CREATURE_SIZE
  self.height = CREATURE_SIZE

  self.inPlay = true

  self.animation =
    Animation(
    {
      frames = {1, 2},
      interval = 0.1
    }
  )
end

function Creature:update(dt)
  self.animation:update(dt)
end

function Creature:render()
  love.graphics.draw(
    gTextures[self.texture],
    gQuads[self.texture][self.color][self.animation:getCurrentFrame()],
    math.floor(self.x),
    math.floor(self.y)
  )
end

function Creature:collides(target)
  return not (self.x + self.width - 2 < target.x or self.x - 2 > target.x + target.width or
    self.y + self.height - 2 < target.y or
    self.y - 2 > target.y + target.height)
end
