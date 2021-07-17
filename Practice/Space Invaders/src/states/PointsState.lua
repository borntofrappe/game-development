PointsState = BaseState:new()

local POINTS_MULTIPLIER = 10
local COUNTDOWN_DURATION = 9

function PointsState:enter()
  self.title = {
    ["text"] = string.upper("Play\n" .. TITLE),
    ["y"] = WINDOW_HEIGHT / 4
  }

  local maxWidth = INVADER_WIDTH + gFonts.normal:getWidth(string.upper(POINTS_MULTIPLIER * INVADERS .. " points\t"))
  local x = WINDOW_WIDTH / 2 - maxWidth / 2
  local y = WINDOW_HEIGHT / 2

  local entries = {}

  for i = 1, INVADERS do
    table.insert(
      entries,
      {
        ["type"] = i,
        ["text"] = string.upper(POINTS_MULTIPLIER * i .. " points"),
        ["x"] = x,
        ["y"] = y + gFonts.normal:getHeight() * 1.5 * (INVADERS - i + 1)
      }
    )
  end

  self.x = x
  self.y = y
  self.maxWidth = maxWidth
  self.entries = entries

  self.startCountdown = {
    ["duration"] = COUNTDOWN_DURATION,
    ["label"] = "startCountdown"
  }

  Timer:after(
    self.startCountdown.duration,
    function()
      gStateMachine:change("start")
    end,
    self.startCountdown.label
  )
end

function PointsState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") or love.keyboard.waspressed("return") then
    Timer:remove(self.startCountdown.label)
    gStateMachine:change("start")
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
