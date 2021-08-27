TransitionState = BaseState:new()

local TWEEN_DURATION = 2
local RADIUS = ((VIRTUAL_WIDTH ^ 2 + VIRTUAL_HEIGHT ^ 2) ^ 0.5) / 2

function TransitionState:new(def)
  local this = {
    ["callback"] = function()
      gStateStack:pop()
      if def.callback then
        def.callback()
      end
    end,
    ["stencil"] = {
      ["r"] = def.isHiding and RADIUS or 0
    }
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function TransitionState:enter()
  Timer:tween(
    TWEEN_DURATION,
    {
      [self.stencil] = {["r"] = self.stencil.r == RADIUS and 0 or RADIUS}
    },
    function()
      self.callback()
    end
  )
end

function TransitionState:update(dt)
  Timer:update(dt)
end

function TransitionState:render()
  love.graphics.stencil(
    function()
      love.graphics.circle("fill", VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, self.stencil.r)
    end,
    "replace",
    1
  )

  love.graphics.setStencilTest("equal", 0)

  love.graphics.setColor(0.173, 0.11, 0.106)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setStencilTest()
end
