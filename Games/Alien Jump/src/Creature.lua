Creature = Class {}

function Creature:init()
  self.type = math.random(2) == 1 and "land" or "sky"
  self.texture = "creatures_" .. self.type
  self.color = math.random(#gQuads[self.texture])

  self.width = CREATURE_WIDTH
  self.height = self.type == "land" and CREATURE_HEIGHT_LAND or CREATURE_HEIGHT_SKY

  self.x = VIRTUAL_WIDTH
  self.y =
    self.type == "land" and VIRTUAL_HEIGHT - self.height or
    VIRTUAL_HEIGHT - self.height - math.random(self.height, math.floor(VIRTUAL_HEIGHT / 2))

  self.points = CREATURE_POINTS[self.type]

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
  return not (self.x + self.width - 1 < target.x or self.x - 1 > target.x + target.width or
    self.y + self.height - 1 < target.y or
    self.y - 1 > target.y + target.height)
end
