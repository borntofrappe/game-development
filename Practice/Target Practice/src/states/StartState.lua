StartState = BaseState:new()

function StartState:enter(params)
  self.terrain = params and params.terrain or Terrain:new()
  self.cannon = params and params.cannon or Cannon:new(self.terrain)
  self.target = params and params.target or Target:new(self.terrain)

  local instruction = string.upper("Play")
  local width = gFonts.normal:getWidth(instruction) * 2
  local height = gFonts.normal:getHeight() * 2

  self.button =
    Button:new(
    WINDOW_WIDTH / 2 - width / 2,
    WINDOW_HEIGHT / 2 + 26,
    width,
    height,
    instruction,
    function()
      gStateMachine:change(
        "play",
        {
          ["terrain"] = self.terrain,
          ["cannon"] = self.cannon,
          ["target"] = self.target
        }
      )
    end
  )
end

function StartState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["terrain"] = self.terrain,
        ["cannon"] = self.cannon,
        ["target"] = self.target
      }
    )
  end

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  self.button:update()
end

function StartState:render()
  self.cannon:render()
  self.target:render()
  self.terrain:render()

  love.graphics.setColor(1, 1, 1, OVERLAY_OPACITY)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(TITLE:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight() - 24, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  self.button:render()
end
