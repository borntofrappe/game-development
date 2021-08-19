SetState = BaseState:new()

local PADDING = 16
local TWEEN_ANIMATION = 1.5
local OFFSET_LOSS = 0.3
local DELAY_PLAY = 1.5

function SetState:enter(params)
  self.tiles = params.tiles
  self.car = params.car
  self.tilesOffset = {
    ["value"] = params.tilesOffset.value,
    ["speed"] = params.tilesOffset.speed
  }

  self.isSet = false
  self.message = string.upper("Go!")

  Timer:tween(
    TWEEN_ANIMATION,
    {
      [self.car] = {["x"] = PADDING},
      [self.tilesOffset] = {["speed"] = params.tilesOffset.speed * (1 - OFFSET_LOSS)}
    },
    function()
      self.isSet = true
      Timer:after(
        DELAY_PLAY,
        function()
          gStateMachine:change("play")
        end
      )
    end
  )
end

function SetState:update(dt)
  Timer:update(dt)

  self.tilesOffset.value = self.tilesOffset.value + self.tilesOffset.speed * dt
  if self.tilesOffset.value >= VIRTUAL_WIDTH then
    self.tilesOffset.value = self.tilesOffset.value % VIRTUAL_WIDTH
  end

  self.car.animation:update(dt)
end

function SetState:render()
  love.graphics.setColor(1, 1, 1)

  love.graphics.push()
  love.graphics.translate(self.tilesOffset.value * -1, 0)
  for k, tile in pairs(self.tiles) do
    love.graphics.draw(gTextures["spritesheet"], gQuads["textures"][tile.id], tile.x, tile.y)
  end
  love.graphics.pop()

  love.graphics.draw(
    gTextures["spritesheet"],
    gQuads["cars"][self.car.color][self.car.animation:getCurrentFrame()],
    self.car.x,
    self.car.y
  )

  love.graphics.setFont(gFonts.normal)
  love.graphics.setColor(0.06, 0.07, 0.19)
  if self.isSet then
    love.graphics.printf(self.message, 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(), VIRTUAL_WIDTH, "center")
  else
    love.graphics.printf("Set", 0, VIRTUAL_HEIGHT * 3 / 4 - gFonts.normal:getHeight(), VIRTUAL_WIDTH, "center")
  end
end
