TitleState = BaseState:new()

local TITLE_MARGIN_TOP = -12
local TITLE_MARGIN_BOTTOM = 68

local INSTRUCTIONS = {
  ["padding"] = {
    ["x"] = 28,
    ["y"] = 11
  },
  ["background"] = {
    ["opacity"] = 0.4,
    ["interval"] = 1.1,
    ["tween"] = 1
  }
}

function TitleState:enter()
  self.overlay = {
    ["opacity"] = 1
  }

  self.title = {
    ["text"] = TITLE,
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight() + TITLE_MARGIN_TOP
  }

  local instructions = {
    ["text"] = "Levels",
    ["y"] = self.title.y + gFonts.large:getHeight() + TITLE_MARGIN_BOTTOM
  }

  local width = gFonts.normal:getWidth(instructions.text) + INSTRUCTIONS.padding.x * 2
  local height = gFonts.normal:getHeight() + INSTRUCTIONS.padding.y * 2
  local x = WINDOW_WIDTH / 2 - width / 2
  local y = instructions.y + gFonts.normal:getHeight() / 2 - height / 2

  instructions.background = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["opacity"] = INSTRUCTIONS.background.opacity
  }

  self.instructions = instructions

  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    },
    function()
      Timer:every(
        INSTRUCTIONS.background.interval,
        function()
          Timer:tween(
            INSTRUCTIONS.background.tween,
            {
              [self.instructions.background] = {
                ["opacity"] = self.instructions.background.opacity == 0 and INSTRUCTIONS.background.opacity or 0
              }
            }
          )
        end,
        true
      )
    end
  )
end

function TitleState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("escape") then
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    if self.overlay.opacity == 0 then
      Timer:reset()
      Timer:tween(
        OVERLAY_TWEEN,
        {
          [self.overlay] = {["opacity"] = 1}
        },
        function()
          gStateMachine:change("select")
        end
      )
    end
  end
end

function TitleState:render()
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, self.instructions.background.opacity)
  love.graphics.rectangle(
    "fill",
    self.instructions.background.x,
    self.instructions.background.y,
    self.instructions.background.width,
    self.instructions.background.height
  )
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.setLineWidth(3)
  love.graphics.rectangle(
    "line",
    self.instructions.background.x,
    self.instructions.background.y,
    self.instructions.background.width,
    self.instructions.background.height
  )
  love.graphics.setFont(gFonts.normal)
  love.graphics.printf(self.instructions.text, 0, self.instructions.y, WINDOW_WIDTH, "center")

  if self.overlay.opacity > 0 then
    love.graphics.setColor(gColors.overlay.r, gColors.overlay.g, gColors.overlay.b, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
