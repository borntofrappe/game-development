GameoverState = BaseState:new()

local OPACITY_CELL = 0.12

local TITLE_MARGIN_BOTTOM = 16

function GameoverState:enter(params)
  love.graphics.setBackgroundColor(COLORS["play-area"].r, COLORS["play-area"].g, COLORS["play-area"].b)

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

  self.interval = {
    ["state"] = false,
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

function GameoverState:update(dt)
  if love.keyboard.waspressed("escape") then
    Timer:remove(self.interval.label)
    gStateMachine:change("start")
  end

  if love.keyboard.waspressed("return") then
    Timer:remove(self.interval.label)
    gStateMachine:change("play")
  end

  Timer:update(dt)
end

function GameoverState:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.canvas)

  love.graphics.setFont(gFonts["large"])
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, TITLE_SHADOW.opacity)
  love.graphics.printf(
    self.title,
    TITLE_SHADOW.x,
    WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight() + TITLE_SHADOW.y,
    WINDOW_WIDTH,
    "center"
  )

  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.printf(self.title, 0, WINDOW_HEIGHT / 2 - gFonts["large"]:getHeight(), WINDOW_WIDTH, "center")

  if self.interval.state then
    love.graphics.setColor(COLORS.text.r, COLORS.text.g, COLORS.text.b)
    love.graphics.setFont(gFonts["normal"])
    love.graphics.printf("Press enter to replay", 0, WINDOW_HEIGHT / 2 + TITLE_MARGIN_BOTTOM, WINDOW_WIDTH, "center")
  end
end
