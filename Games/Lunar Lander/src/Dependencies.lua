require "src/constants"
require "src/Utils"

require "src/Terrain"
require "src/Lander"

require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"
require "src/states/OrbitState"
require "src/states/LandState"
require "src/states/CrashState"

gTextures = {
  ["particle"] = love.graphics.newImage("res/particle.png")
}
