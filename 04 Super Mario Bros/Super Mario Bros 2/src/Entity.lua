Entity = Class {}

function Entity:init(def)
  self.x = def.x
  self.y = def.y

  self.dx = 0
  self.dy = 0

  self.width = def.width
  self.height = def.height

  self.texture = def.texture
  self.stateMachine = def.stateMachine

  self.direction = "right"

  self.map = def.map
end

function Entity:update(dt)
  self.stateMachine:update(dt)
end

function Entity:changeState(state, params)
  self.stateMachine:change(state, params)
end

function Entity:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
    self.direction == "right" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
