TransitionState = BaseState:new()

local TWEEN_DURATION = 1
local RADIUS = ((VIRTUAL_WIDTH ^ 2 + VIRTUAL_HEIGHT ^ 2) ^ 0.5) / 2

function TransitionState:new(def)
  local rStart = def.transitionStart and RADIUS or 0
  local rEnd = rStart == RADIUS and 0 or RADIUS

  local this = {
    ["callback"] = function()
      if not def.prevenDefault then
        gStateStack:pop() -- by default remove the transition
      end

      if def.callback then
        def.callback()
      end
    end,
    ["stencil"] = {
      ["r"] = rStart
    },
    ["wait"] = def.wait
  }

  Timer:tween(
    TWEEN_DURATION,
    {
      [this.stencil] = {["r"] = rEnd}
    },
    function()
      this.callback()
    end
  )

  self.__index = self
  setmetatable(this, self)

  return this
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
