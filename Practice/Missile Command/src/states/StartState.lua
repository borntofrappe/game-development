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
    ["height"] = overlayHeight,
    ["delay"] = 1,
    ["tween"] = 3
  }

  self.overlay = overlay

  self.instruction = {
    ["opacity"] = 0,
    ["tween"] = 1
  }

  Timer:after(
    self.overlay.delay,
    function()
      Timer:tween(
        self.overlay.tween,
        {
          [self.overlay] = {["x"] = self.title.x + gapOffsetX}
        },
        function()
          Timer:tween(
            self.instruction.tween,
            {
              [self.instruction] = {["opacity"] = 1}
            }
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
    Timer:reset()
    gStateMachine:change("serve")
  end
end

function StartState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures.title, self.title.x, self.title.y)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", self.overlay.x, self.overlay.y, self.overlay.width, self.overlay.height)

  love.graphics.setColor(0, 0, 0, self.instruction.opacity)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Play", 0, WINDOW_HEIGHT / 2 + 64, WINDOW_WIDTH, "center")
end
