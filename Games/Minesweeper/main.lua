require "src/Dependencies"

function love.load()
  love.window.setTitle("Minesweeper")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(
    gColors["background-light"].r,
    gColors["background-light"].g,
    gColors["background-light"].b
  )
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(gColors["background-dark"].r, gColors["background-dark"].g, gColors["background-dark"].b)
  love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, MENU_HEIGHT)

  love.graphics.setFont(gFonts["normal"])
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    "Mines: " .. MINES,
    -16,
    MENU_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2,
    WINDOW_WIDTH / 2,
    "right"
  )
  love.graphics.print("Time: 000", WINDOW_WIDTH / 2 + 16, MENU_HEIGHT / 2 - gFonts["normal"]:getHeight() / 2)

  love.graphics.translate(0, MENU_HEIGHT)
  for x = 1, COLUMNS do
    for y = 1, ROWS do
      local color = (x + y) % 2 == 0 and "cell-light" or "cell-dark"
      love.graphics.setColor(gColors[color].r, gColors[color].g, gColors[color].b)
      love.graphics.rectangle(
        "fill",
        PADDING + (x - 1) * CELL_SIZE,
        PADDING + (y - 1) * CELL_SIZE,
        CELL_SIZE,
        CELL_SIZE
      )
    end
  end

  love.graphics.setColor(gColors["reveal-light"].r, gColors["reveal-light"].g, gColors["reveal-light"].b)
  love.graphics.rectangle("fill", PADDING + (4) * CELL_SIZE, PADDING + (4) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
  love.graphics.setColor(gColors["reveal-dark"].r, gColors["reveal-dark"].g, gColors["reveal-dark"].b)
  love.graphics.rectangle("fill", PADDING + (5) * CELL_SIZE, PADDING + (4) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
  love.graphics.setColor(gColors["reveal-light"].r, gColors["reveal-light"].g, gColors["reveal-light"].b)
  love.graphics.rectangle("fill", PADDING + (6) * CELL_SIZE, PADDING + (4) * CELL_SIZE, CELL_SIZE, CELL_SIZE)

  love.graphics.setFont(gFonts["bold"])
  love.graphics.setColor(gColors["number-1"].r, gColors["number-1"].g, gColors["number-1"].b)
  love.graphics.printf(
    1,
    PADDING + (4) * CELL_SIZE,
    PADDING + (4) * CELL_SIZE + CELL_SIZE / 2 - gFonts["bold"]:getHeight() / 2,
    CELL_SIZE,
    "center"
  )
  love.graphics.setColor(gColors["number-2"].r, gColors["number-2"].g, gColors["number-2"].b)
  love.graphics.printf(
    2,
    PADDING + (5) * CELL_SIZE,
    PADDING + (4) * CELL_SIZE + CELL_SIZE / 2 - gFonts["bold"]:getHeight() / 2,
    CELL_SIZE,
    "center"
  )
  love.graphics.setColor(gColors["number-3"].r, gColors["number-3"].g, gColors["number-3"].b)
  love.graphics.printf(
    3,
    PADDING + (6) * CELL_SIZE,
    PADDING + (4) * CELL_SIZE + CELL_SIZE / 2 - gFonts["bold"]:getHeight() / 2,
    CELL_SIZE,
    "center"
  )

  love.graphics.setColor(gColors["mine"].r, gColors["mine"].g, gColors["mine"].b)
  love.graphics.rectangle("fill", PADDING + (3) * CELL_SIZE, PADDING + (7) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.circle(
    "fill",
    PADDING + (3) * CELL_SIZE + CELL_SIZE / 2,
    PADDING + (7) * CELL_SIZE + CELL_SIZE / 2,
    CELL_SIZE / 5
  )
end
