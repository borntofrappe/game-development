PointsState = Class({__includes = BaseState})

function PointsState:init()
  self.delay =
    Timer.after(
    10,
    function()
      self.delay:remove()
      gStateMachine:change("title")
    end
  )
end

function PointsState:update(dt)
  Timer.update(dt)

  if love.keyboard.waspressed("enter") or love.keyboard.waspressed("return") then
    self.delay:remove()
    gStateMachine:change("title")
  end
end

function PointsState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(36 / 255, 191 / 255, 97 / 255, 1)
  love.graphics.printf(string.upper("Play"), 0, WINDOW_HEIGHT / 3 - 24 - 8 - 24, WINDOW_WIDTH, "center")
  love.graphics.printf(string.upper("Space Invaders"), 0, WINDOW_HEIGHT / 3 - 24, WINDOW_WIDTH, "center")

  love.graphics.printf(string.upper("Score Table"), 0, WINDOW_HEIGHT / 2 - 24, WINDOW_WIDTH, "center")

  for i = 0, 3 do
    if i == 0 then
      love.graphics.draw(
        gTextures["spritesheet"],
        gFrames["aliens"][4],
        WINDOW_WIDTH / 2 - 100 - 7.5,
        WINDOW_HEIGHT / 2 + 16
      )

      love.graphics.printf(string.upper("=  ? Points"), 16, WINDOW_HEIGHT / 2 + 16, WINDOW_WIDTH, "center")
    else
      love.graphics.draw(
        gTextures["spritesheet"],
        gFrames["aliens"][(3 - i + 1)][1],
        WINDOW_WIDTH / 2 - 100,
        WINDOW_HEIGHT / 2 + 16 + (i) * 42
      )

      love.graphics.printf(
        string.upper("= " .. (3 - i + 1) * 10 .. " Points"),
        16,
        WINDOW_HEIGHT / 2 + 16 + (i) * 42,
        WINDOW_WIDTH,
        "center"
      )
    end
  end
end
