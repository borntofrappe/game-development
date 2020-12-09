PlayState = BaseState:create()

function PlayState:enter()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end
end

function PlayState:render()
  love.graphics.setColor(gColors["dark"].r, gColors["dark"].g, gColors["dark"].b)

  love.graphics.printf("PlayState", 0, WINDOW_HEIGHT / 2 - gFonts["title"]:getHeight() / 2, WINDOW_WIDTH, "center")
end
