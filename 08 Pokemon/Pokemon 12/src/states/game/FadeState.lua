FadeState = Class({__includes = BaseState})

function FadeState:init(def)
  self.color = def.color
  self.duration = def.duration
  self.opacity = def.opacity == 1 and 0 or 1

  self.callback = function()
    gStateStack:pop()
    if def.callback then
      def.callback()
    end
  end

  Timer.tween(
    self.duration,
    {
      [self] = {opacity = def.opacity}
    }
  ):finish(
    function()
      self.callback()
    end
  )
end

function FadeState:update(dt)
  Timer.update(dt)
end

function FadeState:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.opacity)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
