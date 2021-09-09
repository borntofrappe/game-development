Player = Entity:new()

function Player:new(x, y)
  local this = {
    ["direction"] = "right"
  }

  local def = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = SPRITE_SIZE,
    ["quads"] = "player"
  }

  local stateMachine =
    StateMachine:new(
    {
      ["idle"] = function()
        return PlayerIdleState:new(this)
      end,
      ["walk"] = function()
        return PlayerWalkingState:new(this)
      end,
      ["shoot"] = function()
        return PlayerShootingState:new(this)
      end,
      ["lose"] = function()
        return PlayerLoseState:new(this)
      end
    }
  )

  stateMachine:change("idle")
  def.stateMachine = stateMachine

  Entity.init(this, def)

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  Entity.update(self, dt)
end

function Player:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(
    gTexture,
    gQuads[self.quads][self.currentAnimation:getCurrentFrame()],
    self.direction == "right" and math.floor(self.x) or math.floor(self.x) + self.size,
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
