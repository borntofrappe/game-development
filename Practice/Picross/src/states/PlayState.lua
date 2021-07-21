PlayState = BaseState:new()

local OVERLAY_TWEEN = 0.1

function PlayState:enter()
  self.level = Level:new()

  self.overlay = {
    ["opacity"] = 1
  }
  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    }
  )
end

function PlayState:update(dt)
  Timer:update(dt)
end

function PlayState:render()
  self.level:render()

  if self.overlay.opacity > 0 then
    love.graphics.setColor(1, 1, 1, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
