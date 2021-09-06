CongratsState = BaseState:new()

function CongratsState:enter(params)
  self.offset = params.offset
  self.puzzle = params.puzzle
end

function CongratsState:update(dt)
  -- cheeky way to speed up the timer
  Timer:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") or love.mouse.waspressed(2) then
    Timer:reset()
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("return") or love.mouse.waspressed(1) then
    Timer:reset()
    gStateMachine:change(
      "play",
      {
        ["previousLevel"] = self.puzzle.level
      }
    )
  end
end

function CongratsState:render()
  love.graphics.translate(self.offset, self.offset)
  love.graphics.setColor(0.07, 0.14, 0.07)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("It's " .. self.puzzle.name .. "!", -self.offset, PUZZLE_SIZE + 6, WINDOW_SIZE, "center")

  love.graphics.setColor(1, 1, 1)
  self.puzzle:render()
end
