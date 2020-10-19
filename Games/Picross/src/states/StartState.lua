StartState = Class({__includes = BaseState})

function StartState:init()
  self.level =
    Level(
    {
      ["number"] = 0,
      ["hideHints"] = true
    }
  )
end

function StartState:update(dt)
  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
    gStateMachine:change("select")
  end
end

function StartState:render()
  love.graphics.clear(0.05, 0.05, 0.05)

  love.graphics.setColor(0.9, 0.9, 0.95)
  love.graphics.setFont(gFonts["big"])
  love.graphics.printf("Picross", 0, WINDOW_HEIGHT / 2 - gFonts["big"]:getHeight(), WINDOW_WIDTH, "center")
  love.graphics.setFont(gFonts["normal"])
  love.graphics.printf("StartState", 0, WINDOW_HEIGHT / 2 + 8, WINDOW_WIDTH, "center")
end
