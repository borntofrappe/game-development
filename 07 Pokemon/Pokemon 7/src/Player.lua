Player = Class()

function Player:init(def)
  self.column = def.column
  self.row = def.row

  self.x = (self.column - 1) * TILE_SIZE
  self.y = (self.row - 1) * TILE_SIZE

  self.sprite = def.sprite or 1
  self.direction = def.direction or "down"

  self.stateMachine = def.stateMachine
  self.pokemon = def.pokemon
  self.level = def.level
end

function Player:update(dt)
  self.stateMachine:update(dt)
end

function Player:changeState(state, params)
  self.stateMachine:change(state, params)
end

function Player:render()
  love.graphics.draw(
    gTextures["entities"],
    gFrames["entities"][self.sprite][self.direction][self.currentAnimation:getCurrentFrame()],
    self.x,
    self.y - TILE_SIZE / 4
  )
end
