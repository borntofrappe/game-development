Class = require 'res/lib/class'

require 'Android'
require 'Lollipop'
require 'LollipopPair'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 550
SETTINGS = {
    fullscreen = false,
    resizable = false,
    vsync = true,
}


local background = love.graphics.newImage('res/graphics/background.png')

function love.load()
    love.window.setTitle('Bouncing Android')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, SETTINGS)

    love.mouse.waspressed = false

    gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end
    })

    gStateMachine:change('title')    
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed()
    love.mouse.waspressed = true
end

function love.update(dt)
    gStateMachine:update(dt)

    love.mouse.waspressed = false
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    gStateMachine:render()
end