TitleState = Class({__includes = BaseState})

function TitleState:init()
end

function TitleState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end
  if love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function TitleState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][1], 0, 0)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf(
    "The Legend of Zelda",
    1,
    VIRTUAL_HEIGHT / 2 - gFonts["big"]:getHeight() + 1,
    VIRTUAL_WIDTH,
    "center"
  )
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(
    "The Legend of Zelda",
    0,
    VIRTUAL_HEIGHT / 2 - gFonts["big"]:getHeight(),
    VIRTUAL_WIDTH,
    "center"
  )
end
