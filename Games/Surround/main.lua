require "src/Dependencies"

function love.load()
  love.window.setTitle("Surround")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  love.keyboard.keyPressed = {}

  player = Player:new(math.floor(WINDOW_WIDTH / 2) / CELL_SIZE, math.floor(WINDOW_HEIGHT / 2) / CELL_SIZE)
  translate = {
    ["column"] = 0,
    ["row"] = 0
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
  player:update(dt)
  love.keyboard.keyPressed = {}
end

function love.draw()
  love.graphics.translate((translate.column) * CELL_SIZE, (translate.row) * CELL_SIZE)
  player:render()
end

function updateWorld()
  Timer:every(
    INTERVAL,
    function()
      if player.d.c ~= 0 or player.d.r ~= 0 then
        local hasTrail = false
        local previousTail = {}
        for i, tail in ipairs(player.trail) do
          if tail.column == player.column and tail.row == player.row then
            hasTrail = true
            previousTail = tail
            break
          end
        end

        if not hasTrail then
          table.insert(
            player.trail,
            {
              ["column"] = player.column,
              ["row"] = player.row
            }
          )
        else
        end
      end

      player.column = player.column + player.d.c
      player.row = player.row + player.d.r
      translate.column = translate.column - player.d.c
      translate.row = translate.row - player.d.r
    end
  )
end
