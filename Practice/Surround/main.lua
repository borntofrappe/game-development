require "src/Dependencies"

function love.load()
  love.window.setTitle(TITLE)
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(COLORS["play-area"].r, COLORS["play-area"].g, COLORS["play-area"].b)

  gStateMachine =
    StateMachine:new(
    {
      ["start"] = function()
        return StartState:new()
      end,
      ["play"] = function()
        return PlayState:new()
      end,
      ["gameover"] = function()
        return GameoverState:new()
      end
    }
  )

  gFonts = {
    ["large"] = love.graphics.newFont("res/fonts/font.ttf", 54),
    ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16)
  }

  gSounds = {
    ["gameover"] = love.audio.newSource("res/sounds/gameover.wav", "static"),
    ["play"] = love.audio.newSource("res/sounds/play.wav", "static")
  }

  gStateMachine:change("start")
  love.keyboard.keypressed = {}
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
  gStateMachine:render()
end
