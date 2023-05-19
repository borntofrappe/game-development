require "src/Dependencies"

function love.load()
    love.window.setTitle("Bashout")
    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_OPTIONS)

    gFonts = {
        ["small"] = love.graphics.newFont("res/fonts/font.ttf", 8),
        ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16),
        ["large"] = love.graphics.newFont("res/fonts/font.ttf", 32)
    }

    gTextures = {
        ["background"] = love.graphics.newImage("res/graphics/background.png"),
        ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png")
    }

    gStateMachine =
        StateMachine(
        {
            ["start"] = function()
                return StartState()
            end
        }
    )

    gStateMachine:change("start")

    love.keyboard.keypressed = {}
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    love.keyboard.keypressed[key] = true
end

function love.keyboard.waspressed(key)
    return love.keyboard.keypressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keypressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(gTextures["background"], 0, 0)

    gStateMachine:render()

    push:finish()
end
