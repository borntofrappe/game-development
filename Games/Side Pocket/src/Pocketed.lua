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
  local padding = 12
  local r = 16
  local x = self.panel.x + (padding + r + r * 3 * (#self.balls)) % (self.panel.width - padding)
  local y =
    self.panel.y + padding + r + r * 3 * math.floor((padding + r + r * 3 * (#self.balls)) / (self.panel.width - r))

  table.insert(
    self.balls,
    {
      ["x"] = x,
      ["y"] = y,
      ["r"] = r,
      ["number"] = number
    }
  )
end

function Pocketed:reset()
  self.balls = {}
end

function Pocketed:render()
  self.panel:render()

  love.graphics.setColor(0.9, 0.9, 0.9)
  if #self.balls > 0 then
    for i, ball in ipairs(self.balls) do
      love.graphics.setLineWidth(3)
      love.graphics.circle("line", ball.x, ball.y, ball.r)
      love.graphics.setFont(gFonts["normal"])
      love.graphics.printf(
        ball.number,
        ball.x - ball.r,
        ball.y - gFonts["normal"]:getHeight() / 2,
        ball.r * 2,
        "center"
      )
    end
  else
    love.graphics.setFont(gFonts["big"])
    love.graphics.printf(
      string.upper("Good luck!"),
      self.panel.x,
      self.panel.y + self.panel.height / 2 - gFonts["big"]:getHeight() / 2,
      self.panel.width,
      "center"
    )
  end
end
