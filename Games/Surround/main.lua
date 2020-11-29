require "src/Dependencies"

function love.load()
  love.window.setTitle("Surround")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.3, 0.3, 0.3)

  love.keyboard.keyPressed = {}

  world = {
    ["columns"] = COLUMNS * 2,
    ["rows"] = ROWS * 2,
    ["translate"] = {
      ["columns"] = COLUMNS,
      ["rows"] = ROWS
    }
  }

  p1 =
    Player:new(
    love.math.random(world.columns),
    love.math.random(world.rows),
    {
      ["r"] = 0.16,
      ["g"] = 0.83,
      ["b"] = 0.69
    },
    {
      ["up"] = "w",
      ["right"] = "d",
      ["down"] = "s",
      ["left"] = "a"
    }
  )

  p2 =
    Player:new(
    love.math.random(world.columns),
    love.math.random(world.rows),
    {
      ["r"] = 0.62,
      ["g"] = 0,
      ["b"] = 1
    },
    {
      ["up"] = "up",
      ["right"] = "right",
      ["down"] = "down",
      ["left"] = "left"
    }
  )

  translations = {}
  for i, p in ipairs({p1, p2}) do
    translations[i] = {
      ["column"] = -(p.column - math.floor(world.translate.columns / 4)),
      ["row"] = -(p.row - math.floor(world.translate.rows / 2))
    }
  end

  game = {
    ["world"] = world,
    ["players"] = {p1, p2},
    ["translations"] = translations
  }

  canvases = getCanvases()
  updateGame()
end

function getCanvases()
  local canvases = {}

  for i = 1, #game.players do
    canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.push()

    love.graphics.translate(
      game.translations[i].column * game.players[i].size,
      game.translations[i].row * game.players[i].size
    )

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, game.world.columns * CELL_SIZE, game.world.rows * CELL_SIZE)

    for j = 1, #game.players do
      game.players[j]:render()
    end

    love.graphics.pop()

    love.graphics.setCanvas()
    canvases[i] = canvas
  end

  return canvases
end

function love.keypressed(key)
  love.keyboard.keyPressed[key] = true

  if key == "escape" then
    love.event.quit()
  end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

function love.update(dt)
  Timer:update(dt)
  for i = 1, #game.players do
    game.players[i]:update(dt)
  end

  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")

  for i, canvas in ipairs(canvases) do
    love.graphics.draw(canvas, (i - 1) * CANVAS_WIDTH)
  end
  love.graphics.setColor(0.3, 0.3, 0.3)
end

function updateGame()
  Timer:every(
    INTERVAL,
    function()
      for i = 1, #game.players do
        local p = game.players[i]
        local translation = game.translations[i]

        if p.d.c ~= 0 or p.d.r ~= 0 then
          local hasTrail = false
          local previousTail = {}
          for i, tail in ipairs(p.trail) do
            if tail.column == p.column and tail.row == p.row then
              hasTrail = true
              previousTail = tail
              break
            end
          end

          if not hasTrail then
            table.insert(
              p.trail,
              {
                ["column"] = p.column,
                ["row"] = p.row
              }
            )
          else
          end
        end

        p.column = p.column + p.d.c
        p.row = p.row + p.d.r

        translation.column = translation.column - p.d.c
        translation.row = translation.row - p.d.r

        if p.column < 1 or p.column > game.world.columns or p.row < 1 or p.row > game.world.rows then
          p.column = love.math.random(game.world.columns)
          p.row = love.math.random(game.world.rows)
          p.trail = {}

          translation.column = -(p.column - math.floor(game.world.translate.columns / 4))
          translation.row = -(p.row - math.floor(game.world.translate.rows / 2))
        end
      end

      canvases = getCanvases()
    end
  )
end
