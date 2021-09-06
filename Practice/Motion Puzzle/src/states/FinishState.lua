FinishState = BaseState:new()

function FinishState:enter(params)
  self.offset = params.offset
  self.puzzle = params.puzzle
end

function FinishState:update(dt)
  -- cheeky way to speed up the timer
  Timer:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") or love.mouse.waspressed(2) then
    Timer:reset()
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") or love.mouse.waspressed(1) then
    local level
    repeat
      level = love.math.random(#gQuads.levels)
    until level ~= self.puzzle.level

    Timer:reset()
    gStateMachine:change(
      "play",
      {
        ["level"] = level
      }
    )
  end
end

function FinishState:render()
  love.graphics.translate(self.offset, self.offset)

  love.graphics.setColor(0.07, 0.14, 0.07)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("It's " .. self.puzzle.name .. "!", -self.offset, PUZZLE_SIZE + 6, WINDOW_SIZE, "center")

  love.graphics.setColor(1, 1, 1)
  self.puzzle:render()
end
