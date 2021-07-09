RecordState = BaseState:new()

function RecordState:enter()
  self.record = "--"
  love.filesystem.setIdentity(FOLDER)
  if love.filesystem.getInfo(FILE) then
    for line in love.filesystem.lines(FILE) do
      self.record = line
      break
    end
  end
end

function RecordState:update(dt)
  if love.keyboard.waspressed("return") then
    gStateMachine:change("start")

    gSounds["enter"]:play()
  end
end

function RecordState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(
    string.upper("High score"),
    0,
    VIRTUAL_HEIGHT / 2 - gFonts.large:getHeight() * 3 / 2,
    VIRTUAL_WIDTH,
    "center"
  )

  love.graphics.printf(
    self.record .. " seconds",
    0,
    VIRTUAL_HEIGHT / 2 + gFonts.large:getHeight() / 2,
    VIRTUAL_WIDTH,
    "center"
  )
end
