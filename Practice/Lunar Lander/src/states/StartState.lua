StartState = BaseState:new()

function StartState:enter()
  self.title = {
    ["text"] = TITLE,
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() / 2 - 36
  }

  local instructions = {
    "Good luck",
    "Bonne chance",
    "Viel gluck",
    "Give it your best shot",
    "You can do this",
    "Slow and steady",
    "Patience is key",
    "It's not a sprint"
  }

  self.instruction = {
    ["text"] = instructions[love.math.random(#instructions)],
    ["y"] = self.title.y + gFonts.large:getHeight() + 24,
    ["index"] = 0
  }

  self.interval = {
    ["duration"] = 0.12,
    ["label"] = "typewriter"
  }

  Timer:after(
    0.2,
    function()
      Timer:every(
        self.interval.duration,
        function()
          self.instruction.index = self.instruction.index + 1
          if self.instruction.index == #self.instruction.text then
            Timer:remove(self.interval.label)
          end
        end,
        false,
        self.interval.label
      )
    end
  )
end

function StartState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") and self.instruction.index == #self.instruction.text then
    Timer:remove(self.interval.label)
    gStateMachine:change("play")
  end
end

function StartState:render()
  love.graphics.setColor(0, 0, 0, 0.85)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    self.instruction.text:sub(1, self.instruction.index),
    0,
    self.instruction.y,
    WINDOW_WIDTH,
    "center"
  )
end
