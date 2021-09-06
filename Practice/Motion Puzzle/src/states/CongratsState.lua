CongratsState = BaseState:new()

function CongratsState:enter(params)
  self.offset = params.offset
  self.puzzle = params.puzzle
end

function CongratsState:update(dt)
  -- Timer:update(dt) -- REMOVE COMMENT AS YOU COMPLETED PUZZLE
  -- Timer:update(dt) -- REMOVE COMMENT AS YOU COMPLETED PUZZLE

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("title")
  end

  if love.keyboard.waspressed("return") then
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
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("It's " .. self.puzzle.name .. "!", -self.offset, PUZZLE_SIZE + 12, WINDOW_SIZE, "center")

  love.graphics.setColor(1, 1, 1)
  -- love.graphics.draw(self.border)

  self.puzzle:render()
end
