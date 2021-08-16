VictoryState = BaseState:new()

local SERVE_STATE_DELAY = 5

function VictoryState:enter(params)
  self.data = params.data

  local missiles = 0
  local towns = #self.data.towns

  for i, launchPad in ipairs(self.data.launchPads) do
    if launchPad.inPlay then
      missiles = missiles + launchPad.missiles
      launchPad:restock()
    end
  end

  self.missiles = missiles
  self.towns = towns

  self.title = {
    ["text"] = string.upper("Mission accomplished"),
    ["y"] = WINDOW_HEIGHT / 4 - gFonts.large:getHeight() / 2
  }

  local pointsWidth = gFonts.large:getWidth(self.title.text)
  self.points = {
    ["x"] = WINDOW_WIDTH / 2 - pointsWidth / 2,
    ["y"] = self.title.y + gFonts.large:getHeight() + 40,
    ["width"] = pointsWidth,
    ["previous"] = self.data.points,
    ["missiles"] = self.missiles * 5,
    ["towns"] = self.towns * 150
  }

  self.data.points = self.data.points + self.points.missiles + self.points.towns

  Timer:after(
    SERVE_STATE_DELAY,
    function()
      gStateMachine:change(
        "serve",
        {
          ["data"] = self.data
        }
      )
    end
  )
end

function VictoryState:update(dt)
  -- Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()
    gStateMachine:change(
      "serve",
      {
        ["data"] = self.data
      }
    )
  end
end

function VictoryState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setFont(gFonts.normal)

  love.graphics.printf("Points", self.points.x, self.points.y, self.points.width, "left")
  love.graphics.printf(
    "Missiles " .. "x " .. self.missiles,
    self.points.x,
    self.points.y + 50,
    self.points.width,
    "left"
  )
  love.graphics.printf("Towns " .. "x " .. self.towns, self.points.x, self.points.y + 100, self.points.width, "left")

  love.graphics.printf(self.points.previous, self.points.x, self.points.y, self.points.width, "right")
  love.graphics.printf(self.points.missiles, self.points.x, self.points.y + 50, self.points.width, "right")
  love.graphics.printf(self.points.towns, self.points.x, self.points.y + 100, self.points.width, "right")

  love.graphics.setLineWidth(2)
  love.graphics.line(self.points.x, self.points.y + 140, self.points.x + self.points.width, self.points.y + 140)
  love.graphics.printf(self.data.points, self.points.x, self.points.y + 150, self.points.width, "right")
end
