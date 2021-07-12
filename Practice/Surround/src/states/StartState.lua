StartState = BaseState:new()

local TRAIL_OPACITY = 0.25

local OFFSET_SHADOW_X = -2
local OFFSET_SHADOW_Y = 3
local OPACITY_SHADOW = 0.4

local TITLE_PADDING_TOP = 12
local TITLE_PADDING_BOTTOM = 6
local TITLE_MARGIN_BOTTOM = 16

local INTERVAL_DELAY = 2
local INTERVAL_DURATION = 0.5

function StartState:new()
  local title = TITLE:upper()
  local width = gFonts["large"]:getWidth(title)
  local height = gFonts["large"]:getHeight()

  local this = {
    ["title"] = title,
    ["x"] = WINDOW_WIDTH / 2 - width / 2,
    ["y"] = WINDOW_HEIGHT / 2 - height,
    ["width"] = width,
    ["height"] = height,
    ["toggleOpacity"] = {
      ["state"] = true,
      ["label"] = "toggle"
    }
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function StartState:enter()
  Timer:after(
    INTERVAL_DELAY,
    function()
      Timer:every(
        INTERVAL_DURATION,
        function()
          self.toggleOpacity.state = not self.toggleOpacity.state
        end,
        self.toggleOpacity.label
      )
    end
  )
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    Timer:remove(self.toggleOpacity.label)
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.toggleOpacity.label)
    gStateMachine:change("play")
  end

  Timer:update(dt)
end

function StartState:render()
  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b, OPACITY_SHADOW)
  love.graphics.printf(self.title, OFFSET_SHADOW_X, self.y + OFFSET_SHADOW_Y, WINDOW_WIDTH, "center")
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
  love.graphics.printf(self.title, 0, self.y, WINDOW_WIDTH, "center")

  love.graphics.setColor(COLORS["player-1"].r, COLORS["player-1"].g, COLORS["player-1"].b)
  love.graphics.rectangle(
    "fill",
    self.x + self.width - CELL_SIZE,
    self.y - CELL_SIZE - TITLE_PADDING_TOP,
    CELL_SIZE,
    CELL_SIZE
  )

  love.graphics.setColor(COLORS["player-1"].r, COLORS["player-1"].g, COLORS["player-1"].b, TRAIL_OPACITY)
  love.graphics.rectangle("fill", self.x, self.y - CELL_SIZE - TITLE_PADDING_TOP, self.width, CELL_SIZE)

  love.graphics.setColor(COLORS["player-2"].r, COLORS["player-2"].g, COLORS["player-2"].b)
  love.graphics.rectangle("fill", self.x, self.y + self.height + TITLE_PADDING_BOTTOM, CELL_SIZE, CELL_SIZE)

  love.graphics.setColor(COLORS["player-2"].r, COLORS["player-2"].g, COLORS["player-2"].b, TRAIL_OPACITY)
  love.graphics.rectangle("fill", self.x, self.y + self.height + TITLE_PADDING_BOTTOM, self.width, CELL_SIZE)

  if self.toggleOpacity.state then
    love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
    love.graphics.setFont(gFonts["normal"])
    love.graphics.printf(
      "Press enter to play",
      0,
      self.y + self.height + TITLE_PADDING_BOTTOM + CELL_SIZE + TITLE_MARGIN_BOTTOM,
      WINDOW_WIDTH,
      "center"
    )
  end
end
