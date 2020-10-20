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

gFonts = {
  ["big"] = love.graphics.newFont("res/fonts/font.ttf", 52),
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 16),
  ["small"] = love.graphics.newFont("res/fonts/font.ttf", 12)
}

gTextures = {
  ["background"] = love.graphics.newImage("res/graphics/background.png")
}

gColors = {
  ["text"] = {["r"] = 0.07, ["g"] = 0.07, ["b"] = 0.2, ["a"] = 1},
  ["shadow"] = {["r"] = 0.05, ["g"] = 0.05, ["b"] = 0.15, ["a"] = 0.2},
  ["highlight"] = {["r"] = 0.95, ["g"] = 0.84, ["b"] = 0.07, ["a"] = 1}
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
