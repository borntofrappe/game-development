GameoverState = BaseState:new()

local COLUMNS = math.floor(WINDOW_WIDTH / CELL_SIZE)
local ROWS = math.floor(WINDOW_HEIGHT / CELL_SIZE)

local OFFSET_SHADOW_X = -2
local OFFSET_SHADOW_Y = 3
local OPACITY_SHADOW = 0.4

local OPACITY_CELL = 0.12

local INTERVAL_DELAY = 2
local INTERVAL_DURATION = 0.5

local TITLE_MARGIN_BOTTOM = 16

function GameoverState:enter(params)
  self.winner = params and params.winner
  self.color = self.winner and COLORS[self.winner] or COLORS.text

  local title = self.winner and "Congrats!" or "Draw!"
  self.title = title:upper()

  local grid = {}
  for column = 1, COLUMNS do
    for row = 1, ROWS do
      if (column + row) % 2 == 0 then
        table.insert(grid, Cell:new(column, row, CELL_SIZE))
      end
    end
  end

  local canvas = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setCanvas(canvas)
  love.graphics.setBlendMode("alpha", "premultiplied")

  love.graphics.setColor(self.color.r, self.color.g, self.color.b, OPACITY_CELL)
  for k, cell in pairs(grid) do
    cell:render()
  end

  love.graphics.setBlendMode("alpha")
  love.graphics.setCanvas()
  self.canvas = canvas

  self.toggleOpacity = {
    ["state"] = false,
    ["label"] = "toggle"
  }

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

function GameoverState:update(dt)
  if love.keyboard.waspressed("escape") then
    Timer:remove(self.toggleOpacity.label)
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.toggleOpacity.label)
    gStateMachine:change("play")
  end

  Timer:update(dt)
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.canvas)

  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, OPACITY_SHADOW)
  love.graphics.printf(
    self.title,
    OFFSET_SHADOW_X,
    WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight() + OFFSET_SHADOW_Y,
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.printf(self.title, 0, WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight(), WINDOW_WIDTH, "center")

  if self.toggleOpacity.state then
    love.graphics.setFont(gFonts["normal"])
    love.graphics.printf("Press enter to replay", 0, WINDOW_HEIGHT / 2 + TITLE_MARGIN_BOTTOM, WINDOW_WIDTH, "center")
  end
end
