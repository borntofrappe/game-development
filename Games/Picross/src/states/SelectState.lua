SelectState = Class({__includes = BaseState})

function SelectState:init()
  self.level =
    Level(
    {
      ["number"] = 0,
      ["hideHints"] = true
    }
  )
end

function SelectState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("play")
  end
end

function SelectState:render()
  love.graphics.clear(0.05, 0.05, 0.05)

  love.graphics.setColor(0.9, 0.9, 0.95)
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("SelectState", 0, WINDOW_HEIGHT - 8 - gFonts["normal"]:getHeight(), WINDOW_WIDTH, "center")

  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  self.level:render()
end
