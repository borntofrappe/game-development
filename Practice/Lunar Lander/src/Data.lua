Data = {}

local FUEL = 1000
local FUEL_SPEED = 20
local PADDING_X = 18
local PADDING_Y = 8

function Data:new(lander)
  local yStart = PADDING_Y
  local yGap = gFonts.small:getHeight() * 1.5
  local widthRightColumn = gFonts.small:getWidth("Horizontal Velocity 12 →")

  local this = {
    ["score"] = {
      ["label"] = "Score",
      ["value"] = 0,
      ["format"] = function(value)
        local formattedValue = string.format("%04d", value)
        return string.format("Score% 8s", formattedValue)
      end,
      ["x"] = PADDING_X,
      ["y"] = yStart
    },
    ["time"] = {
      ["label"] = "Time",
      ["value"] = 0,
      ["format"] = function(value)
        local seconds = value
        local minutes = math.floor(seconds / 60)
        seconds = seconds - minutes * 60

        local formattedValue = string.format("%02d:%02d", minutes, seconds)

        return string.format("Time% 9s", formattedValue)
      end,
      ["x"] = PADDING_X,
      ["y"] = yStart + yGap
    },
    ["fuel"] = {
      ["label"] = "Fuel",
      ["value"] = FUEL,
      ["format"] = function(value)
        local formattedValue = string.format("%04d", value)
        return string.format("Fuel% 9s", formattedValue)
      end,
      ["x"] = PADDING_X,
      ["y"] = yStart + yGap * 2
    },
    ["altitude"] = {
      ["label"] = "Altitude",
      ["value"] = WINDOW_HEIGHT - lander.body:getY(),
      ["format"] = function(value)
        return string.format("Altitude % 14d", value)
      end,
      ["x"] = WINDOW_WIDTH - widthRightColumn - PADDING_X,
      ["y"] = yStart
    },
    ["horizontal-speed"] = {
      ["label"] = "Horizontal speed",
      ["value"] = 0,
      ["format"] = function(value)
        local suffix = " "
        if value > 0 then
          suffix = "→"
        elseif value < 0 then
          suffix = "←"
        end

        return string.format("Horizontal Speed % 4d " .. suffix, value)
      end,
      ["x"] = WINDOW_WIDTH - widthRightColumn - PADDING_X,
      ["y"] = yStart + yGap
    },
    ["vertical-speed"] = {
      ["label"] = "Vertical Speed",
      ["value"] = 0,
      ["format"] = function(value)
        local suffix = " "
        if value > 0 then
          suffix = "↓"
        elseif value < 0 then
          suffix = "↑"
        end

        return string.format("Vertical Speed % 6d " .. suffix, value)
      end,
      ["x"] = WINDOW_WIDTH - widthRightColumn - PADDING_X,
      ["y"] = yStart + yGap * 2
    }
  }

  self.__index = self
  setmetatable(this, self)

  return this
end

function Data:updateTime()
  self.time.value = self.time.value + 1
end

function Data:updateFuel(dt)
  self.fuel.value = math.max(0, self.fuel.value - dt * FUEL_SPEED)
end

function Data:setAltitude(lander)
  self.altitude.value = WINDOW_HEIGHT - lander.body:getY()
end

function Data:setVelocity(lander)
  local vx, vy = lander.body:getLinearVelocity()
  self["horizontal-speed"].value = vx
  self["vertical-speed"].value = vy
end

function Data:updateScore()
  -- score considering the time and altitude metrics
  self.score.value = self.score.value + 100
end

function Data:refuel()
  self.fuel.value = self.fuel.value + 200
end

function Data:render()
  love.graphics.setFont(gFonts.small)
  for _, metric in pairs(self) do -- it works :)
    love.graphics.print(metric.format(metric.value):upper(), metric.x, metric.y)
  end
end
