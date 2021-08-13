StartState = BaseState:new()

function StartState:enter()
  local titleWidth = gTextures.title:getWidth()
  local titleHeight = gTextures.title:getHeight()
  local gapOffsetY = 30
  local gapOffsetX = 329
  local gapHeight = 8

  local title = {
    ["x"] = math.floor(WINDOW_WIDTH / 2 - titleWidth / 2),
    ["y"] = WINDOW_HEIGHT / 2 - titleHeight
  }

  self.title = title

  local overlayWidth = 20
  local overlayHeight = 4
  local overlay = {
    ["x"] = self.title.x - overlayWidth - 2,
    ["y"] = self.title.y + gapOffsetY + gapHeight / 2 - overlayHeight / 2,
    ["width"] = overlayWidth,
    ["height"] = overlayHeight
  }

  self.overlay = overlay

  self.showInstruction = false

  Timer:after(
    1,
    function()
      Timer:tween(
        3,
        {
          [self.overlay] = {["x"] = self.title.x + gapOffsetX}
        },
        function()
          Timer:after(
            0.75,
            function()
              self.showInstruction = true
            end
          )
        end
      )
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    if self.showInstruction then
      gStateMachine:change("play")
    end
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.title, self.title.x, self.title.y)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", self.overlay.x, self.overlay.y, self.overlay.width, self.overlay.height)

  if self.showInstruction then
    love.graphics.setFont(gFonts.normal)
    love.graphics.printf("Play", 0, WINDOW_HEIGHT / 2 + 48, WINDOW_WIDTH, "center")
  end
end
