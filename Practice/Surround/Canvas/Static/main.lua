require "Cell"

local WINDOW_WIDTH = 520
local WINDOW_HEIGHT = 380

local CANVAS_WIDTH = math.floor(WINDOW_WIDTH / 2)
local CANVAS_HEIGHT = WINDOW_HEIGHT

local CELL_SIZE = 20
local COLUMNS = math.floor(CANVAS_WIDTH / CELL_SIZE)
local ROWS = math.floor(CANVAS_HEIGHT / CELL_SIZE)

local COLORS = {
  {
    ["r"] = 0.15,
    ["g"] = 0.66,
    ["b"] = 0.88,
    ["a"] = 0.65
  },
  {
    ["r"] = 0.9,
    ["g"] = 0.29,
    ["b"] = 0.6,
    ["a"] = 0.65
  }
}

local cells = {}

for column = 1, COLUMNS do
  for row = 1, ROWS do
    local size = CELL_SIZE

    local everyOther = (column + row) % 2 == 1
    local color = everyOther and COLORS[1] or COLORS[2]

    local x = (column - 1) * size
    local y = (row - 1) * size

    table.insert(cells, Cell:new(x, y, size, color))
  end
end

local canvas

function love.load()
  love.window.setTitle("Canvas Static")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.94, 0.94, 0.94)

  canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
  love.graphics.setCanvas(canvas)
  for k, cell in pairs(cells) do
    cell:render()
  end
  love.graphics.setCanvas()
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(canvas)

  love.graphics.translate(CANVAS_WIDTH, 0)
  love.graphics.setBlendMode("alpha")
  love.graphics.draw(canvas)
end
