require "src/Dependencies"

function love.load()
  math.randomseed(os.time())
  love.window.setTitle("Tetris")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(
    gColors["background"].r,
    gColors["background"].g,
    gColors["background"].b,
    gColors["background"].a
  )

  grid =
    Grid:new(
    {
      ["columns"] = COLUMNS,
      ["rows"] = ROWS
    }
  )

  score =
    DescriptionList:new(
    {
      ["term"] = "Score",
      ["description"] = 0,
      ["column"] = 4 + grid.columns,
      ["row"] = 2,
      ["width"] = 5,
      ["height"] = 3
    }
  )

  lines =
    DescriptionList:new(
    {
      ["term"] = "Lines",
      ["description"] = 0,
      ["column"] = 4 + grid.columns,
      ["row"] = 6,
      ["width"] = 5,
      ["height"] = 2
    }
  )

  panel =
    Panel:new(
    {
      ["column"] = 4 + grid.columns,
      ["row"] = 9,
      ["width"] = 5,
      ["height"] = 5
    }
  )

  tetriminoses = {
    ["current"] = Tetriminos:new(
      {
        ["column"] = math.floor(grid.columns / 2),
        ["row"] = 1,
        ["grid"] = grid
      }
    ),
    ["next"] = Tetriminos:new(
      {
        ["column"] = 5.5 + grid.columns,
        ["row"] = 10.5,
        ["center"] = true
      }
    )
  }

  timer = 0
  interval = 0.5

  love.keyboard.keyPressed = {}
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  if tetriminoses.current.inPlay then
    timer = timer + dt
    if timer > interval then
      timer = timer % interval
      tetriminoses.current:move("down")
    end

    if love.keyboard.wasPressed("right") then
      tetriminoses.current:move("right")
    elseif love.keyboard.wasPressed("left") then
      tetriminoses.current:move("left")
    elseif love.keyboard.wasPressed("down") then
      tetriminoses.current:move("down")
      timer = 0
    end
  else
    for i, brick in ipairs(tetriminoses.current.bricks) do
      local column = brick.column
      local row = brick.row
      local color = brick.color
      grid.bricks[row][column] =
        Brick:new(
        {
          ["column"] = column,
          ["row"] = row,
          ["color"] = color
        }
      )
    end

    tetriminoses.current =
      Tetriminos:new(
      {
        ["type"] = tetriminoses.next.type,
        ["color"] = tetriminoses.next.color,
        ["column"] = math.floor(grid.columns / 2),
        ["row"] = 1,
        ["grid"] = grid
      }
    )

    tetriminoses.next =
      Tetriminos:new(
      {
        ["column"] = 5.5 + grid.columns,
        ["row"] = 10.5,
        ["center"] = true
      }
    )

    local rowsCleared = {}
    for row = grid.rows, 1, -1 do
      local isRowCleared = true
      for column = 1, grid.columns do
        if grid.bricks[row][column] == "" then
          isRowCleared = false
          break
        end
      end

      if isRowCleared then
        table.insert(rowsCleared, row)

        for c = 1, grid.columns do
          grid.bricks[row][c] = ""
        end
      end
    end

    if #rowsCleared > 0 then
      for i, rowCleared in ipairs(rowsCleared) do
        for row = rowCleared, 1, -1 do
          for column = 1, grid.columns do
            if grid.bricks[row][column] ~= "" then
              grid.bricks[row][column].row = grid.bricks[row][column].row + 1
              grid.bricks[row + 1][column] = grid.bricks[row][column]
              grid.bricks[row][column] = ""
            end
          end
        end
      end
      lines.description = lines.description + #rowsCleared
      score.description = score.description + 100 * #rowsCleared + math.random(4) * 25
    else
      for column = 1, grid.columns do
        local row = 1
        if grid.bricks[row][column] ~= "" then
          for i, brick in ipairs(tetriminoses.current.bricks) do
            if brick.row == row and brick.column == column then
              grid:reset()
              lines.description = 0
              score.description = 0
              break
            end
          end
        end
      end
    end
  end

  if love.keyboard.wasPressed("space") then
    tetriminoses.current:rotate()
  end

  if love.keyboard.wasPressed("escape") then
    love.event.quit()
  end

  love.keyboard.keyPressed = {}
end

function love.draw()
  for row = 1, grid.rows + 1 do
    love.graphics.draw(gTextures["tiles"], gFrames["tiles"][#gFrames["tiles"]], 0, (row - 1) * TILE_SIZE)
    love.graphics.draw(
      gTextures["tiles"],
      gFrames["tiles"][#gFrames["tiles"]],
      TILE_SIZE + grid.columns * TILE_SIZE,
      (row - 1) * TILE_SIZE
    )
  end

  score:render()
  lines:render()
  panel:render()
  tetriminoses.next:render()

  if showGrid then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(gColors["text"].r, gColors["text"].g, gColors["text"].b, 0.5)
    for column = 1, math.floor(WINDOW_WIDTH / TILE_SIZE) + 1 do
      love.graphics.line((column - 1) * TILE_SIZE, 0, (column - 1) * TILE_SIZE, WINDOW_HEIGHT)
    end
    for row = 1, math.floor(WINDOW_HEIGHT / TILE_SIZE) + 1 do
      love.graphics.line(0, (row - 1) * TILE_SIZE, WINDOW_WIDTH, (row - 1) * TILE_SIZE)
    end
    love.graphics.setColor(1, 1, 1, 1)
  end

  love.graphics.translate(TILE_SIZE, 0)

  grid:render()
  tetriminoses.current:render()
end
