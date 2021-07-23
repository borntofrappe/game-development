VictoryState = BaseState:new()

local EXTRA_TWEEN = 0.3
local TITLE_TWEEN = 0.25

function VictoryState:enter(params)
  self.overlay = {
    ["opacity"] = 0
  }

  self.index = params.index
  self.offset = params.offset
  self.level = params.level
  self.data = params.data

  self.title = {
    ["text"] = self.level.name,
    ["opacity"] = 0
  }

  for k, cell in pairs(self.level.grid) do
    if cell.value == "x" then
      cell.value = nil
    end
  end

  Timer:tween(
    EXTRA_TWEEN,
    {
      [self.level] = {["extraOpacity"] = 0}
    },
    function()
      Timer:tween(
        TITLE_TWEEN,
        {
          [self.title] = {["opacity"] = 1}
        }
      )
    end
  )
end

function VictoryState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
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

  if love.keyboard.waspressed("return") then
    Timer:tween(
      OVERLAY_TWEEN,
      {
        [self.overlay] = {["opacity"] = 1}
      },
      function()
        gStateMachine:change(
          "select",
          {
            ["index"] = self.index
          }
        )
      end
    )
  end
end

function VictoryState:render()
  self.data:render()

  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, self.title.opacity)
  love.graphics.setFont(gFonts.medium)
  love.graphics.printf(
    self.title.text,
    WINDOW_WIDTH / 10,
    WINDOW_HEIGHT / 2,
    WINDOW_WIDTH / 2 - WINDOW_WIDTH / 10,
    "center"
  )

  love.graphics.push()
  love.graphics.translate(self.offset.x, self.offset.y)

  self.level:render()

  love.graphics.pop()

  if self.overlay.opacity > 0 then
    love.graphics.setColor(gColors.overlay.r, gColors.overlay.g, gColors.overlay.b, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
