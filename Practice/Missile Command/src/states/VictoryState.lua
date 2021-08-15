VictoryState = BaseState:new()

local SERVE_STATE_DELAY = 3

function VictoryState:enter(params)
  self.data = params.data

  local points = self.data.points

  for i, launchPad in ipairs(self.data.launchPads) do
    if launchPad.inPlay then
      points = points + 5 * launchPad.missiles
      launchPad:restock()
    end
  end

  points = points + #self.data.towns * 150

  self.data.points = points

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
  Timer:update(dt)

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
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    string.upper("Mission accomplished"),
    0,
    WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2,
    WINDOW_WIDTH,
    "center"
  )
end
