Pocketed = {}
Pocketed.__index = Pocketed

function Pocketed:new()
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

  this = {
    ["panel"] = panel,
    ["balls"] = {}
  }

  setmetatable(this, self)
  return this
end

function Pocketed:addBall(number)
  local x = self.panel.x + 14 + 16 + (#self.balls) % 4 * (self.panel.width - 14) / 4
  local y = #self.balls < 4 and self.panel.y + self.panel.height / 3 or self.panel.y + self.panel.height * 2 / 3

  table.insert(
    self.balls,
    {
      ["x"] = x,
      ["y"] = y,
      ["r"] = 14,
      ["number"] = number
    }
  )
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
