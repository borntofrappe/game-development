StartState = BaseState:new()

local TITLE_PADDING_TOP = 12
local TITLE_PADDING_BOTTOM = 6
local TITLE_MARGIN_BOTTOM = 16

function StartState:new()
  love.graphics.setBackgroundColor(COLORS["play-area"].r, COLORS["play-area"].g, COLORS["play-area"].b)

  local title = TITLE:upper()
  local width = gFonts["large"]:getWidth(title)
  local height = gFonts["large"]:getHeight()

  local this = {
    ["title"] = title,
    ["x"] = WINDOW_WIDTH / 2 - width / 2,
    ["y"] = WINDOW_HEIGHT / 2 - height,
    ["width"] = width,
    ["height"] = height
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function StartState:enter()
  self.interval = {
    ["state"] = true,
    ["delay"] = INSTRUCTION_INTERVAL.delay,
    ["duration"] = INSTRUCTION_INTERVAL.duration,
    ["label"] = INSTRUCTION_INTERVAL.label
  }

  Timer:after(
    self.interval.delay,
    function()
      Timer:every(
        self.interval.duration,
        function()
          self.interval.state = not self.interval.state
        end,
        self.interval.label
      )
    end
  )
end

function StartState:update(dt)
  if love.keyboard.waspressed("escape") then
    Timer:remove(self.interval.label)
    love.event.quit()
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.interval.label)
    gStateMachine:change("play")
  end

  Timer:update(dt)
end

function StartState:render()
  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b, TITLE_SHADOW.opacity)
  love.graphics.printf(self.title, TITLE_SHADOW.x, self.y + TITLE_SHADOW.y, WINDOW_WIDTH, "center")
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

  if self.interval.state then
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
