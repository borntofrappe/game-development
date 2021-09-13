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
        ["dino"] = GenerateQuadsDino(gTextures.spritesheet)
    }

    gFonts = {
        ["large"] = love.graphics.newFont("res/fonts/font.ttf", 24),
        ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 8)
    }

    gGround = Ground:new()
    gDino = Dino:new()

    gStateStack = StateStack:new({WaitingState:new()})

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
    gStateStack:update(dt)

    love.keyboard.keypressed = {}
end

function love.draw()
    push:start()

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    gGround:render()
    gDino:render()

    gStateStack:render()

    push:finish()
end
