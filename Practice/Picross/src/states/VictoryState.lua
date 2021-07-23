VictoryState = BaseState:new()

local TITLE_DELAY = 0.5
local TITLE_TWEEN = 0.4

function VictoryState:enter(params)
  self.active = false

  self.overlay = {
    ["opacity"] = 0
  }

  self.level = params.level
  self.data = params.data

  gLevelsCleared[self.level.index] = true

  self.title = {
    ["text"] = self.level.name,
    ["opacity"] = 0
  }

  Timer:after(
    TITLE_DELAY,
    function()
      self.active = true
      Timer:tween(
        TITLE_TWEEN,
        {
          [self.title] = {["opacity"] = 1}
        }
      )
    end
  )
end

function VictoryState:goToTitleState()
  self.active = false
  Timer:reset()
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

function VictoryState:goToSelectState()
  self.active = false
  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 1}
    },
    function()
      gStateMachine:change(
        "select",
        {
          ["index"] = self.level.index
        }
      )
    end
  )
end

function VictoryState:update(dt)
  Timer:update(dt)

  if love.mouse.waspressed(1) then
    if self.active then
      local x, y = love.mouse:getPosition()
      if x ^ 2 + y ^ 2 < BACK_BUTTON_RADIUS ^ 2 then
        self:goToTitleState()
      else
        self:goToSelectState()
      end
    end
  end

  if love.keyboard.waspressed("escape") then
    if self.active then
      self:goToTitleState()
    end
  end

  if love.keyboard.waspressed("return") then
    if self.active then
      self:goToSelectState()
    end
  end
end

function VictoryState:render()
  self.data:render()

  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b, self.title.opacity)
  love.graphics.setFont(gFonts.medium)
  love.graphics.printf(
    self.title.text,
    WINDOW_WIDTH / 10,
    WINDOW_HEIGHT / 2,
    WINDOW_WIDTH / 2 - WINDOW_WIDTH / 10,
    "center"
  )

  self.level:render()

  if gMouseInput then
    drawBackButton()
  end

  if not self.active then
    love.graphics.setColor(gColors.overlay.r, gColors.overlay.g, gColors.overlay.b, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
