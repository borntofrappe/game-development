ScrollState = Class {__includes = BaseState}

function ScrollState:init(def)
  self.player = def.player
  self.bushes = {}
  self.coins = {}

  self.player:changeState("walk")
  self.translateX = 0

  self.score = 0
end

function ScrollState:update(dt)
  self.player:update(dt)

  if self.player.y == VIRTUAL_HEIGHT - self.player.height then
    if (love.keyboard.wasPressed("up") or love.keyboard.wasPressed("w")) then
      self.player:changeState("jump")
    end

    if love.keyboard.wasPressed("down") or love.keyboard.wasPressed("s") then
      self.player:changeState("squat")
      gStateStack:push(
        PauseState(
          {
            player = self.player
          }
        )
      )
    end
  end

  self.translateX = self.translateX + SCROLL_SPEED * dt

  if #self.bushes == 0 and math.random(100) == 1 then
    table.insert(self.bushes, Bush())
  elseif #self.coins == 0 and math.random(100) == 1 then
    table.insert(self.coins, Coin())
  end

  if self.translateX >= VIRTUAL_WIDTH then
    self.translateX = 0
  end

  for i, bush in ipairs(self.bushes) do
    bush.x = bush.x - SCROLL_SPEED * dt
    if bush.x + bush.width < 0 then
      bush.inPlay = false
    end
  end

  for i, bush in ipairs(self.bushes) do
    if not bush.inPlay then
      table.remove(self.bushes, i)
    end
  end

  for i, coin in ipairs(self.coins) do
    coin.x = coin.x - SCROLL_SPEED * dt
    if coin.x + coin.width < 0 then
      coin.inPlay = false
    end
    if coin:collides(self.player) then
      coin.inPlay = false
      gScore["current"] = gScore["current"] + coin.points
    end
  end

  for i, coin in ipairs(self.coins) do
    if not coin.inPlay then
      table.remove(self.coins, i)
    end
  end
end

function ScrollState:render()
  love.graphics.translate(-self.translateX, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][gBackgroundVariant], 0, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][gBackgroundVariant], VIRTUAL_WIDTH, 0)
  love.graphics.translate(self.translateX, 0)

  for i, bush in ipairs(self.bushes) do
    bush:render()
  end

  for i, coin in ipairs(self.coins) do
    coin:render()
  end

  self.player:render()
end
