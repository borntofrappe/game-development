PlayState = BaseState:new()

function PlayState:enter(params)
  self.data = params.data
end

function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    gStateMachine:change("start")
  end
end

function PlayState:render()
  self.data:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Here you'd play", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
