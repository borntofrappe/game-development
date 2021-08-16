ServeState = BaseState:new()

local PLAY_STATE_DELAY = 2.5

function ServeState:enter(params)
  self.data = params and params.data or Data:new()

  Timer:after(
    PLAY_STATE_DELAY,
    function()
      gStateMachine:change(
        "play",
        {
          ["data"] = self.data
        }
      )
    end
  )
end

function ServeState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    Timer:reset()
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:reset()
    gStateMachine:change(
      "play",
      {
        ["data"] = self.data
      }
    )
  end
end

function ServeState:render()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Defend Cairo", 0, WINDOW_HEIGHT / 2 - gFonts.normal:getHeight() / 2, WINDOW_WIDTH, "center")
end
