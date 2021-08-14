ServeState = BaseState:new()

local PLAY_STATE_DELAY = 2.5

function ServeState:enter()
  self.data = Data:new()

  Timer:after(
    PLAY_STATE_DELAY,
    function()
      Timer:reset()
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
end

function ServeState:render()
  self.data:render()

  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(
    "Player x" .. self.data.lives .. "\nDefend Cairo",
    0,
    WINDOW_HEIGHT / 2 - gFonts.normal:getHeight(),
    WINDOW_WIDTH,
    "center"
  )
end
