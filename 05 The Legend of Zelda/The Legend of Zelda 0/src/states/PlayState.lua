PlayState = Class({__includes = BaseState})

function PlayState:init()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end
  if love.keyboard.wasPressed("return") then
    gStateMachine:change("gameover")
  end
end

function PlayState:render()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

  love.graphics.setFont(gFonts["big"])
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Play", 0, VIRTUAL_HEIGHT / 2 - gFonts["big"]:getHeight(), VIRTUAL_WIDTH, "center")
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("Dungeon goes here", 0, VIRTUAL_HEIGHT / 2 + gFonts["big"]:getHeight(), VIRTUAL_WIDTH, "center")
end
