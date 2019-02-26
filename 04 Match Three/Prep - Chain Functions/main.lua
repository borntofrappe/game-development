-- require dependencies.lua, itself calling for the necessary resources
require 'src/Dependencies'

-- in the load function set up the screen with the push library
function love.load()
  -- title of the screen
  love.window.setTitle('Chain Chain Chain')

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

  -- maximum amount of time the shapes can take to complete the transition
  TIMER_MAX = 1
  -- variable accumulating the value of dt
  timer = 0

  -- describe the shape ultimately drawn on the screen
  shape = {
    x = 0,
    y = 0,
    width = 25,
    height = 25
  }

  -- define the tween
  Timer.tween(TIMER_MAX, {
    [shape] = { x = VIRTUAL_WIDTH - shape.width, y = 0}
    -- use the :finish() function to chain tweens one after the other
  }):finish(function()
      Timer.tween(TIMER_MAX, {
        [shape] = { x = VIRTUAL_WIDTH - shape.width, y = VIRTUAL_HEIGHT - shape.height}
      }):finish(function()
        Timer.tween(TIMER_MAX, {
          [shape] = { x = 0, y = VIRTUAL_HEIGHT - shape.height}
        }):finish(function()
          Timer.tween(TIMER_MAX, {
            [shape] = { x = 0, y = 0}
          })
        end)
      end)
    end)

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

-- in the update function update the position of the shape using dt, baseX, baseY and the table of destinations
function love.update(dt)
  -- upate the shape through Timer.update(dt)
  Timer.update(dt)

  -- update the timer just to give the visual in the top left corner
  if timer <= TIMER_MAX * 4 then
    timer = timer + dt
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
  love.graphics.rectangle('fill', shape.x, shape.y, shape.width, shape.height)


  love.graphics.setColor(0.15,1,0.55,1)
  love.graphics.setFont(gFonts['normal'])
  love.graphics.print(tostring(timer), 8, 8)


  push:finish()
end