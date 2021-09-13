ServeState = BaseState:new()

function ServeState:enter()
  local x = gDino.x + gDino.width + 2
  local y = 0
  self.overlay = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = VIRTUAL_WIDTH - x,
    ["height"] = VIRTUAL_HEIGHT - y
  }

  self.isTransitioning = false
end

function ServeState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    if not self.isTransitioning then
      self.isTransitioning = true

      Timer:tween(
        2,
        {
          [self.overlay] = {["x"] = VIRTUAL_WIDTH}
        },
        function()
          -- here you'd start playing
        end
      )
    end
  end
end

function ServeState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.overlay.x, self.overlay.y, self.overlay.width, self.overlay.height)
end
