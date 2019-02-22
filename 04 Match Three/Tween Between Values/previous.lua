-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Time keeps passing by')

  -- table for the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['normal'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['big'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['humongous'] = love.graphics.newFont('fonts/font.ttf', 56)
  }

  -- virtualization through the push library
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
  -- table in which to store the last recorded key press
  love.keyboard.keyPressed = {}


  -- variable update with the dt value
  timer = 0
  -- variables describing the size and most importantly coordinates of the shape
  size = 50
  shapeX = 0
  shapeY = VIRTUAL_HEIGHT / 2 - size / 2

  -- constant describing the duration of the chage
  MOVE_DURATION = 2
  -- variable describing the final value assumed by shapeX
  endX = VIRTUAL_WIDTH - size

end

-- in the resize function update the resolution through the push library
function love.resize(width, height)
  push:resize(width, height)
end

-- in the keypressed function keep track of the key being pressed in keyPressed
function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

-- create a function to check whether a specific key was recorded in the keyPressed table
function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end

-- in the update function update the position of the shape using dt and a constant for the speed
function love.update(dt)
  -- as long as timer is less than the constant value the change is supposed to take
  if timer <= MOVE_DURATION then
    -- update timer
    timer = timer + dt
    -- increment the horizontal coordinate to move the shape until endX
    --[[
      if the expression looks confusing think og it in increments:
      - timer/MOVE_DURATION gives a fraction increasing in time, and most importantly in the [0-1] range (1 and change given that timer can go past the MOVE_DURATION)
      - multiplying that fraction by the last coordiante the shape can assume you get the movement, progressively toward the right
      - clamping the coordinate to the minimum between last coordinate and the result of that computation allows the shape to stop exactly at math.min
    ]]
    shapeX = math.min(endX, endX * (timer / MOVE_DURATION))
  end

  -- listen for a key press on the escape key, at which point quit the application
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  -- reset keyPressed to an empty table
  love.keyboard.keyPressed = {}
end

-- in the draw function render the current time in the top left corner and a shape according to an x coordinate updated in the update function
function love.draw()
  push:start()

  love.graphics.setColor(1,1,1,1)
  love.graphics.setFont(gFonts['normal'])

  love.graphics.print(
    tostring(timer),
    8,
    8
  )

  love.graphics.rectangle('fill', shapeX, shapeY, size, size)


  push:finish()
end