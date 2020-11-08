ScrollState = Class {__includes = BaseState}

function ScrollState:init(def)
  self.player =
    Player(
    {
      ["stateMachine"] = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ["jump"] = function()
            return PlayerJumpState(self.player)
          end,
          ["squat"] = function()
            return PlayerSquatState(self.player)
          end,
          ["walk"] = function()
            return PlayerWalkState(self.player)
          end
        }
      )
    }
  )

  self.player:changeState("walk")

  self.bushes = {}
  self.coins = {}
  self.creatures = {}

  self.translateX = 0

  self.score = 0
end

function ScrollState:update(dt)
  self.player:update(dt)

  if self.player.y == VIRTUAL_HEIGHT - self.player.height then
    if (love.keyboard.wasPressed("up") or love.keyboard.wasPressed("w")) then
      self.player:changeState("jump")
      gSounds["jump"]:play()
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

  if #self.creatures == 0 then
    table.insert(self.creatures, Creature())
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
      gSounds["pickup"]:play()
    end
  end

  for i, coin in ipairs(self.coins) do
    if not coin.inPlay then
      table.remove(self.coins, i)
    end
  end

  for i, creature in ipairs(self.creatures) do
    creature:update(dt)
    creature.x = creature.x - SCROLL_SPEED_CREATURE * dt
    if creature.x + creature.width < 0 then
      creature.inPlay = false
    end
    if creature:collides(self.player) then
      gStateStack:push(GameoverState())
      gSounds["hit"]:play()
    end
  end

  for i, creature in ipairs(self.creatures) do
    if not creature.inPlay then
      table.remove(self.creatures, i)
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

  for i, creature in ipairs(self.creatures) do
    creature:render()
  end

  self.player:render()
end
