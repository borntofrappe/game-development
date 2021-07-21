TitleState = BaseState:new()

local TITLE_MARGIN_BOTTOM = 64
local INSTRUCTIONS_PADDING = {
  ["x"] = 28,
  ["y"] = 11
}
local INSTRUCTIONS_BACKGROUND_OPACITY = 0.25
local INSTRUCTIONS_BACKGROUND_INTERVAL = 1.1
local INSTRUCTIONS_BACKGROUND_TWEEN = INSTRUCTIONS_BACKGROUND_INTERVAL - 0.1

local OVERLAY_DELAY = 0.05
local OVERLAY_TWEEN = 0.75

function TitleState:enter()
  self.overlay = {
    ["opacity"] = 1
  }

  self.title = {
    ["text"] = TITLE,
    ["y"] = WINDOW_HEIGHT / 2 - gFonts.large:getHeight()
  }

  local instructions = {
    ["text"] = "Play",
    ["y"] = self.title.y + gFonts.large:getHeight() + TITLE_MARGIN_BOTTOM
  }

  local width = gFonts.normal:getWidth(instructions.text) + INSTRUCTIONS_PADDING.x * 2
  local height = gFonts.normal:getHeight() + INSTRUCTIONS_PADDING.y * 2
  local x = WINDOW_WIDTH / 2 - width / 2
  local y = instructions.y + gFonts.normal:getHeight() / 2 - height / 2

  instructions.background = {
    ["x"] = x,
    ["y"] = y,
    ["width"] = width,
    ["height"] = height,
    ["opacity"] = INSTRUCTIONS_BACKGROUND_OPACITY
  }

  self.instructions = instructions

  Timer:after(
    OVERLAY_DELAY,
    function()
      Timer:tween(
        OVERLAY_TWEEN,
        {
          [self.overlay] = {["opacity"] = 0}
        },
        function()
          Timer:every(
            INSTRUCTIONS_BACKGROUND_INTERVAL,
            function()
              Timer:tween(
                INSTRUCTIONS_BACKGROUND_TWEEN,
                {
                  [self.instructions.background] = {
                    ["opacity"] = self.instructions.background.opacity == 0 and INSTRUCTIONS_BACKGROUND_OPACITY or 0
                  }
                }
              )
            end,
            true
          )
        end
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
          gStateMachine:change("play")
        end
      )
    end
  end
end

function TitleState:render()
  love.graphics.setColor(0.07, 0.07, 0.2)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf(self.title.text, 0, self.title.y, WINDOW_WIDTH, "center")

  love.graphics.setColor(0.05, 0.05, 0.15, self.instructions.background.opacity)
  love.graphics.rectangle(
    "fill",
    self.instructions.background.x,
    self.instructions.background.y,
    self.instructions.background.width,
    self.instructions.background.height
  )
  love.graphics.setColor(0.07, 0.07, 0.2)
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
    love.graphics.setColor(1, 1, 1, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
