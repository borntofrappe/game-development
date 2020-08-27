ScoreTableState = Class({__includes = BaseState})

function ScoreTableState:init()
  Timer.after(
    10,
    function()
      gStateMachine:change("title")
    end
  )
end

function ScoreTableState:update(dt)
  Timer.update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    Timer.clear()
    gStateMachine:change("title")
  end
end

function ScoreTableState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(36 / 255, 191 / 255, 97 / 255, 1)
  love.graphics.printf(string.upper("Play"), 0, WINDOW_HEIGHT / 3 - 24 - 8 - 24, WINDOW_WIDTH, "center")
  love.graphics.printf(string.upper("Space Invaders"), 0, WINDOW_HEIGHT / 3 - 24, WINDOW_WIDTH, "center")

  love.graphics.printf(string.upper("Score Table"), 0, WINDOW_HEIGHT / 2 - 24, WINDOW_WIDTH, "center")

  for i = 1, 3 do
    love.graphics.draw(
      gTextures["space-invaders"],
      gFrames["aliens"][(3 - i + 1)][1],
      WINDOW_WIDTH / 2 - 100,
      WINDOW_HEIGHT / 2 + 16 + (i - 1) * 42
    )

    love.graphics.printf(
      string.upper("= " .. (3 - i + 1) * 10 .. " Points"),
      16,
      WINDOW_HEIGHT / 2 + 16 + (i - 1) * 42,
      WINDOW_WIDTH,
      "center"
    )
  end
end
