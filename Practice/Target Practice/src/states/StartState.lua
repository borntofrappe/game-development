StartState = BaseState:new()

function StartState:enter(params)
  if params and params.reset then
    gTerrain = Terrain:new()
    gCannon = Cannon:new(gTerrain)
    gTarget = Target:new(gTerrain)
  end

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
      gStateMachine:change("play")
    end
  )
end

function StartState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change("play")
  end

  if love.mouse.waspressed(2) or love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  self.button:update()
end

function StartState:render()
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.15, 0.16, 0.22)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(TITLE:upper(), 0, WINDOW_HEIGHT / 2 - gFonts.large:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  self.button:render()
end
