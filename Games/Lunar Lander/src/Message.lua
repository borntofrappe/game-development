Message = {}
Message.__index = Message

function Message:new(text, callback)
  this = {
    ["text"] = text,
    ["index"] = 1,
    ["callback"] = callback,
    ["timerInterval"] = 0,
    ["timerDelay"] = 0,
    ["x"] = 0,
    ["y"] = WINDOW_HEIGHT / 2 - gFonts["message"]:getHeight(),
    ["width"] = WINDOW_WIDTH,
    ["align"] = "center"
  }

  setmetatable(this, self)
  return this
end

function Message:update(dt)
  if self.index >= #self.text then
    self.timerDelay = self.timerDelay + dt
    if self.timerDelay >= TIMER_DELAY then
      self.timerDelay = 0
      self.callback()
    end
  else
    self.timerInterval = self.timerInterval + dt
    if self.timerInterval > TIMER_INTERVAL then
      self.timerInterval = self.timerInterval % TIMER_INTERVAL
      self.index = self.index + 1
    end
  end
end

function Message:render()
  love.graphics.setColor(0.85, 0.85, 0.85)
  love.graphics.setFont(gFonts["message"])
  love.graphics.printf(self.text:sub(1, self.index), self.x, self.y, self.width, self.align)
end
