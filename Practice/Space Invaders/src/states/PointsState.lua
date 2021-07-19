PointsState = BaseState:new()

local TITLE_STATE_DELAY = 9

function PointsState:enter()
  self.title = {
    ["text"] = string.upper("Play\n" .. TITLE),
    ["y"] = WINDOW_HEIGHT / 4
  }

  local maxWidth =
    INVADER_WIDTH + gFonts.normal:getWidth(string.upper(INVADER_POINTS_MULTIPLIER * INVADER_TYPES .. " points\t"))
  local x = WINDOW_WIDTH / 2 - maxWidth / 2
  local y = WINDOW_HEIGHT / 2

  local entries = {}

  for type = 1, INVADER_TYPES do
    table.insert(
      entries,
      {
        ["type"] = type,
        ["text"] = string.upper(INVADER_POINTS_MULTIPLIER * type .. " points"),
        ["x"] = x,
        ["y"] = y + gFonts.normal:getHeight() * 1.5 * (INVADER_TYPES - type + 1)
      }
    )
  end

  self.x = x
  self.y = y
  self.maxWidth = maxWidth
  self.entries = entries

  self.delay = {
    ["duration"] = TITLE_STATE_DELAY,
    ["label"] = "title-state-delay"
  }

  Timer:after(
    self.delay.duration,
    function()
      gStateMachine:change("title")
    end,
    self.delay.label
  )
end

function PointsState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") or love.keyboard.waspressed("return") then
    Timer:remove(self.delay.label)
    gStateMachine:change("title")
  end
end

function PointsState:render()
  love.graphics.setColor(0.14, 0.75, 0.38)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.draw(
    gTextures["spritesheet"],
    gFrames["bonus-invader"],
    self.x - (INVADER_BONUS_WIDTH - INVADER_WIDTH) / 2,
    self.y
  )
  love.graphics.print(" = ", self.x + INVADER_WIDTH, self.y)
  love.graphics.printf(string.upper("? points"), self.x, self.y, self.maxWidth, "right")

  for k, entry in pairs(self.entries) do
    love.graphics.draw(gTextures["spritesheet"], gFrames["invaders"][entry.type][1], entry.x, entry.y)
    love.graphics.print(" = ", entry.x + INVADER_WIDTH, entry.y)
    love.graphics.printf(entry.text, entry.x, entry.y, self.maxWidth, "right")
  end
end
