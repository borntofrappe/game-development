Enemy = Entity:new()

function Enemy:new(x, y)
  local this = {}

  local def = {
    ["x"] = 0,
    ["y"] = 0,
    ["size"] = SPRITE_SIZE,
    ["direction"] = "right",
    ["quads"] = "enemy"
  }

  local stateMachine =
    gStateMachine:new(
    {
      ["idle"] = function()
        return EnemyIdleState:new(this)
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

function Enemy:update(dt)
  Entity.update(self, dt)
end

function Enemy:render()
  Entity.render(self)
end
