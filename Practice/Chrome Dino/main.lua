require "src/Dependencies"

function love.load()
    love.window.setTitle("Chrome Dino")

    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)

    gTextures = {
        ["spritesheet"] = love.graphics.newImage("res/graphics/spritesheet.png"),
        ["ground"] = love.graphics.newImage("res/graphics/ground.png")
    }

    gQuads = {
        ["dino"] = GenerateQuadsDino(gTextures.spritesheet),
        ["cloud"] = GenerateQuadCloud(gTextures.spritesheet),
        ["cacti"] = GenerateQuadsCacti(gTextures.spritesheet),
        ["bird"] = GenerateQuadsBird(gTextures.spritesheet)
    }

    gFonts = {
        ["large"] = love.graphics.newFont("res/fonts/font.ttf", 24),
        ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 8)
    }

    gStateMachine =
        StateMachine:new(
        {
            ["wait"] = function()
                return WaitingState:new()
            end,
            ["play"] = function()
                return PlayingState:new()
            end,
            ["stop"] = function()
                return StoppedState:new()
            end
        }
    )

    gStateMachine:change("wait")

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

    gStateMachine:render()

    push:finish()
end
