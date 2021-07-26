StartState = BaseState:new()

function StartState:enter()
  self.player = Player:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function StartState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["player"] = self.player
      }
    )
  end

  if love.keyboard.waspressed("right") or love.keyboard.waspressed("left") then
    self.player:change("default")
  end

  if love.keyboard.waspressed("up") then
    self.player:change("flying")
  end

  if love.keyboard.waspressed("down") then
    self.player:change("falling")
  end
end

function StartState:render()
  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Start", 0, 8, WINDOW_WIDTH, "center")

  self.player:render()
end
