VictoryState = BaseState:new()

local OVERLAY_TWEEN = 0.1

function VictoryState:enter(params)
  self.overlay = {
    ["opacity"] = 0
  }

  self.offset = params.offset
  self.level = params.level
  self.data = params.data

  self.title = {
    ["text"] = self.level.name,
    ["opacity"] = 0
  }

  for k, cell in pairs(self.level.grid) do
    if cell.value == "x" then
      cell.value = nil
    end
  end

  Timer:tween(
    0.2,
    {
      [self.level] = {["extraOpacity"] = 0},
      [self.title] = {["opacity"] = 1}
    }
  )
end

function VictoryState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:tween(
      OVERLAY_TWEEN,
      {
        [self.overlay] = {["opacity"] = 1}
      },
      function()
        gStateMachine:change("title")
      end
    )
  end
end

function VictoryState:render()
  self.data:render()

  love.graphics.setColor(0.07, 0.07, 0.2, self.title.opacity)
  love.graphics.setFont(gFonts.medium)
  love.graphics.printf(
    self.title.text,
    WINDOW_WIDTH / 10,
    WINDOW_HEIGHT / 2,
    WINDOW_WIDTH / 2 - WINDOW_WIDTH / 10,
    "center"
  )

  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)

  self.level:render()

  love.graphics.pop()

  if self.overlay.opacity > 0 then
    love.graphics.setColor(1, 1, 1, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
