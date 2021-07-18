PauseState = BaseState:new()

function PauseState:enter(params)
  self.collisions = params.collisions
  self.invaders = params.invaders
  self.player = params.player
  self.interval = params.interval
end

function PauseState:update(dt)
  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    gStateMachine:change(
      "play",
      {
        ["collisions"] = self.collisions,
        ["invaders"] = self.invaders,
        ["player"] = self.player,
        ["interval"] = self.interval
      }
    )
  end
end

function PauseState:render()
  self.collisions:render()
  self.invaders:render()
  self.player:render()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    string.upper("Pause"),
    0,
    WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2,
    WINDOW_WIDTH,
    "center"
  )
end
