Pocketed = {}
Pocketed.__index = Pocketed

function Pocketed:new(numbers)
  local panel =
    Panel:new(
    {
      ["x"] = WINDOW_WIDTH / 2 + 20,
      ["y"] = 8,
      ["width"] = WINDOW_WIDTH / 2 - 28,
      ["height"] = WINDOW_HEIGHT / 3,
      ["lineWidth"] = 6,
      ["rx"] = 16
    }
  )

  local numbers = numbers or {}

  local balls = {}
  for i = 1, #numbers do
    local x = panel.x + 14 + 16 + (i - 1) % 4 * (panel.width - 14) / 4
    local y = i <= 4 and panel.y + panel.height / 3 or panel.y + panel.height * 2 / 3

    table.insert(
      balls,
      {
        ["x"] = x,
        ["y"] = y,
        ["r"] = 14,
        ["number"] = numbers[i]
      }
    )
  end

  this = {
    ["panel"] = panel,
    ["balls"] = balls
  }

  setmetatable(this, self)
  return this
end

function Pocketed:render()
  self.panel:render()

  if #self.balls > 0 then
    for i, ball in ipairs(self.balls) do
      love.graphics.setLineWidth(3)
      love.graphics.circle("line", ball.x, ball.y, ball.r)
      love.graphics.printf(ball.number, ball.x - ball.r, ball.y - gFonts["ui"]:getHeight() / 2, ball.r * 2, "center")
    end
  else
    love.graphics.setFont(gFonts["title"])
    love.graphics.printf(
      string.upper("Good luck!"),
      self.panel.x,
      self.panel.y + self.panel.height / 2 - gFonts["title"]:getHeight() / 2,
      self.panel.width,
      "center"
    )
  end
end
