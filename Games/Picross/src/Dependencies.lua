Class = require "res/lib/class"
Timer = require "res/lib/timer"

require "src/Levels"
require "src/Level"
require "src/Cell"

require "src/constants"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/SelectState"
require "src/states/PlayState"
require "src/states/VictoryState"

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 52),
  ["medium"] = love.graphics.newFont("res/fonts/font.ttf", 28),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16),
  ["small"] = love.graphics.newFont("res/fonts/font.ttf", 12)
}

gSizes = {
  ["height-font-big"] = gFonts["big"]:getHeight(),
  ["height-font-normal"] = gFonts["normal"]:getHeight(),
  ["height-font-medium"] = gFonts["medium"]:getHeight(),
  ["height-font-small"] = gFonts["small"]:getHeight()
}

gTextures = {
  ["background"] = love.graphics.newImage("res/graphics/background.png")
}

gColors = {
  ["text"] = {["r"] = 0.07, ["g"] = 0.07, ["b"] = 0.2, ["a"] = 1},
  ["shadow"] = {["r"] = 0.05, ["g"] = 0.05, ["b"] = 0.15, ["a"] = 0.15},
  ["highlight"] = {["r"] = 0.98, ["g"] = 0.85, ["b"] = 0.05, ["a"] = 1}
}

gSounds = {
  ["confirm"] = love.audio.newSource("res/sounds/confirm.wav", "static"),
  ["eraser"] = love.audio.newSource("res/sounds/eraser.wav", "static"),
  ["pen"] = love.audio.newSource("res/sounds/pen.wav", "static"),
  ["select"] = love.audio.newSource("res/sounds/select.wav", "static"),
  ["victory"] = love.audio.newSource("res/sounds/victory.wav", "static"),
  ["music"] = love.audio.newSource("res/sounds/music.mp3", "static")
}

function formatTimer(seconds)
  local seconds = seconds
  local hours = math.floor(seconds / 3600)
  seconds = seconds - hours * 3600
  local minutes = math.floor(seconds / 60)
  seconds = seconds - minutes * 60

  local h = hours >= 10 and hours or 0 .. hours
  local m = minutes >= 10 and minutes or 0 .. minutes
  local s = seconds >= 10 and seconds or 0 .. seconds

  return h .. ":" .. m .. ":" .. s
end
