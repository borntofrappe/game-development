GameoverState = Class({__includes = BaseState})

function GameoverState:init()
end

function GameoverState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("play")
  end
  if love.keyboard.wasPressed("return") then
    gStateMachine:change("title")
  end
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][2], 0, 0)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf("Gameover", 1, VIRTUAL_HEIGHT / 2 - gFonts["big"]:getHeight() + 1, VIRTUAL_WIDTH, "center")
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Gameover", 0, VIRTUAL_HEIGHT / 2 - gFonts["big"]:getHeight(), VIRTUAL_WIDTH, "center")
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf(
    "Better luck next time",
    1,
    VIRTUAL_HEIGHT / 2 + gFonts["big"]:getHeight() + 1,
    VIRTUAL_WIDTH,
    "center"
  )
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(
    "Better luck next time",
    0,
    VIRTUAL_HEIGHT / 2 + gFonts["big"]:getHeight(),
    VIRTUAL_WIDTH,
    "center"
  )
end
