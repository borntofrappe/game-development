SelectState = BaseState:new()

local OVERLAY_TWEEN = 0.1
local LEVELS_MARGIN_BOTTOM = 48

local SELECTION_BACKGROUND_OPACITY = 0.3
local SELECTION_BACKGROUND_INTERVAL = 1.1
local SELECTION_BACKGROUND_TWEEN = SELECTION_BACKGROUND_INTERVAL - 0.1

function SelectState:enter()
  self.index = 1

  local spaceAround = 40
  local spaceBetween = 22
  local totalWidth = WINDOW_WIDTH - spaceAround * 2 - spaceBetween * (#LEVELS + 1)

  local size = totalWidth / #LEVELS + 1

  self.size = size
  self.spaceAround = spaceAround

  local levels = {}
  for i, level in ipairs(LEVELS) do
    table.insert(
      levels,
      {
        ["offset"] = {
          ["x"] = size + spaceBetween,
          ["y"] = 0
        }
      }
    )
  end

  self.levels = levels

  self.selection = {
    ["opacity"] = SELECTION_BACKGROUND_OPACITY
  }

  self.overlay = {
    ["opacity"] = 1
  }

  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    },
    function()
      Timer:every(
        SELECTION_BACKGROUND_INTERVAL,
        function()
          Timer:tween(
            SELECTION_BACKGROUND_TWEEN,
            {
              [self.selection] = {["opacity"] = self.selection.opacity == 0 and SELECTION_BACKGROUND_OPACITY or 0}
            }
          )
        end,
        true
      )
    end
  )
end

function SelectState:update(dt)
  Timer:update(dt)

  if love.keyboard.waspressed("right") then
    if self.overlay.opacity == 0 and self.index < #self.levels then
      self.index = self.index + 1
    end
  end

  if love.keyboard.waspressed("left") then
    if self.overlay.opacity == 0 and self.index > 1 then
      self.index = self.index - 1
    end
  end

  if love.keyboard.waspressed("escape") then
    if self.overlay.opacity == 0 then
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
  end

  if love.keyboard.waspressed("return") then
    if self.overlay.opacity == 0 then
      Timer:tween(
        OVERLAY_TWEEN,
        {
          [self.overlay] = {["opacity"] = 1}
        },
        function()
          gStateMachine:change(
            "play",
            {
              ["index"] = self.index
            }
          )
        end
      )
    end
  end
end

function SelectState:render()
  love.graphics.push()

  love.graphics.translate(self.spaceAround - self.size, WINDOW_HEIGHT / 2 - self.size)

  for i, level in ipairs(self.levels) do
    love.graphics.translate(level.offset.x, level.offset.y)

    if i == self.index then
      love.graphics.setColor(0.05, 0.05, 0.15, self.selection.opacity)
      love.graphics.rectangle("fill", 0, 0, self.size, self.size)
    end

    love.graphics.setColor(0.07, 0.07, 0.2)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", 0, 0, self.size, self.size)
  end

  love.graphics.pop()

  love.graphics.setFont(gFonts.normal)
  love.graphics.printf("Level " .. self.index, 0, WINDOW_HEIGHT / 2 + LEVELS_MARGIN_BOTTOM, WINDOW_WIDTH, "center")

  if self.overlay.opacity > 0 then
    love.graphics.setColor(1, 1, 1, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
