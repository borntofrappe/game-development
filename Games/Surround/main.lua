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
      ["r"] = 0.16, -- [0.62, 0.16]
      ["g"] = 0.83, -- [0, 0.83]
      ["b"] = 0.69 -- [1, 0.69]
    },
    {
      ["up"] = "up",
      ["right"] = "right",
      ["down"] = "down",
      ["left"] = "left"
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
      ["up"] = "w",
      ["right"] = "d",
      ["down"] = "s",
      ["left"] = "a"
    }
  )

  translate = {
    ["column"] = -(p1.column - math.floor(world.translate.columns / 2)),
    ["row"] = -(p1.row - math.floor(world.translate.rows / 2))
  }

  updateWorld()
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
  for i, p in ipairs({p1, p2}) do
    p:update(dt)
  end

  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.translate((translate.column) * CELL_SIZE, (translate.row) * CELL_SIZE)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, world.columns * CELL_SIZE, world.rows * CELL_SIZE)
  p1:render()
  p2:render()
end

function updateWorld()
  Timer:every(
    INTERVAL,
    function()
      for i, p in ipairs({p1, p2}) do
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
      end

      translate.column = translate.column - p1.d.c
      translate.row = translate.row - p1.d.r

      if p1.column < 1 or p1.column > world.columns or p1.row < 1 or p1.row > world.rows then
        p1 = Player:new(love.math.random(world.columns), love.math.random(world.rows))

        translate = {
          ["column"] = -(p1.column - math.floor(world.translate.columns / 2)),
          ["row"] = -(p1.row - math.floor(world.translate.rows / 2))
        }
      end
    end
  )
end
