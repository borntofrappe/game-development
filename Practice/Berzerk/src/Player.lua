Player = Entity:new()

function Player:new(x, y)
  local this = {}

  local def = {
    ["x"] = x,
    ["y"] = y,
    ["size"] = SPRITE_SIZE,
    ["direction"] = "right",
    ["quads"] = "player"
  }

  local stateMachine =
    gStateMachine:new(
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
      ["gameover"] = function()
        return PlayerGameoverState:new(this)
      end
    }
  )

  stateMachine:change("idle")
  def.stateMachine = stateMachine

  Entity.init(self, def)

  self.__index = self
  setmetatable(this, self)

  return this
end

function Player:update(dt)
  Entity.update(self, dt)
end

function Player:render()
  Entity.render(self)
end
