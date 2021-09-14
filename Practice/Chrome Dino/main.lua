require "src/Dependencies"

local shader

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

    gFont = love.graphics.newFont("res/fonts/font.ttf", 8)
    love.graphics.setFont(gFont)

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

    gNight = false

    shader =
        love.graphics.newShader [[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
            vec4 pixel = Texel(texture, texture_coords);
            pixel.r = 1.0 - pixel.r;
            pixel.g = 1.0 - pixel.g;
            pixel.b = 1.0 - pixel.b;
            return pixel;
        }
        ]]

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

    if gNight then
        love.graphics.setShader(shader)
    end

    gStateMachine:render()

    if gNight then
        love.graphics.setShader()
    end

    push:finish()
end
