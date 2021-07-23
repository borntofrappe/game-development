SelectState = BaseState:new()

local LEVELS_MARGIN_BOTTOM = 52
local PADDING_PERCENTAGE = 0.25

local SELECTION_BACKGROUND = {
  ["opacity"] = 0.4,
  ["interval"] = 1.1,
  ["tween"] = 1
}

function SelectState:enter(params)
  self.overlay = {
    ["opacity"] = 1
  }

  local spaceAround = 40
  local spaceBetween = 22
  local totalWidth = WINDOW_WIDTH - spaceAround * 2 - spaceBetween * (#LEVELS - 1)

  local size = totalWidth / #LEVELS
  local padding = math.floor(size * PADDING_PERCENTAGE)
  local gridSize = size - padding * 2

  self.size = size
  self.spaceAround = spaceAround

  local levels = {}
  for i, level in ipairs(LEVELS) do
    local x = spaceAround + (i - 1) * (size + spaceBetween)
    local y = WINDOW_HEIGHT / 2 - size
    table.insert(
      levels,
      {
        ["x"] = x,
        ["y"] = y,
        ["level"] = Level:new(0, x + padding, y + padding, gridSize, true)
      }
    )
  end

  self.levels = levels

  local index = 1
  if params and params.index then
    index = params.index
  end

  self.selection = {
    ["index"] = index,
    ["opacity"] = SELECTION_BACKGROUND.opacity
  }

  Timer:tween(
    OVERLAY_TWEEN,
    {
      [self.overlay] = {["opacity"] = 0}
    },
    function()
      Timer:every(
        SELECTION_BACKGROUND.interval,
        function()
          Timer:tween(
            SELECTION_BACKGROUND.tween,
            {
              [self.selection] = {["opacity"] = self.selection.opacity == 0 and SELECTION_BACKGROUND.opacity or 0}
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
    if self.overlay.opacity == 0 and self.selection.index < #self.levels then
      self.selection.index = self.selection.index + 1
    end
  end

  if love.keyboard.waspressed("left") then
    if self.overlay.opacity == 0 and self.selection.index > 1 then
      self.selection.index = self.selection.index - 1
    end
  end

  if love.keyboard.waspressed("escape") then
    if self.overlay.opacity == 0 then
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
          gStateMachine:change(
            "play",
            {
              ["index"] = self.selection.index
            }
          )
        end
      )
    end
  end
end

function SelectState:render()
  for i, level in ipairs(self.levels) do
    if i == self.selection.index then
      love.graphics.setColor(gColors.shadow.r, gColors.shadow.g, gColors.shadow.b, self.selection.opacity)
      love.graphics.rectangle("fill", level.x, level.y, self.size, self.size)
    end

    love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", level.x, level.y, self.size, self.size)

    level.level:render()
  end

  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(gColors.text.r, gColors.text.g, gColors.text.b)
  love.graphics.printf(
    "Level " .. self.selection.index,
    0,
    WINDOW_HEIGHT / 2 + LEVELS_MARGIN_BOTTOM,
    WINDOW_WIDTH,
    "center"
  )

  if self.overlay.opacity > 0 then
    love.graphics.setColor(gColors.overlay.r, gColors.overlay.g, gColors.overlay.b, self.overlay.opacity)
    love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
  end
end
