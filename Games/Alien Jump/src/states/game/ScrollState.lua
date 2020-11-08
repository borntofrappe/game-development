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

  self.backgroundX = 0
  self.scrollSpeed = SCROLL_SPEED
  self.spawnOdds = SPAWN_ODDS
  self.spawnScore = 0
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

  self.backgroundX = self.backgroundX + self.scrollSpeed * dt

  if #self.bushes == 0 then
    table.insert(self.bushes, Bush())
  end

  if #self.coins == 0 and math.random(self.spawnOdds * 2) == 1 then
    table.insert(self.coins, Coin())
  end

  if #self.creatures == 0 and math.random(self.spawnOdds) == 1 then
    table.insert(self.creatures, Creature())
  end

  if self.backgroundX >= VIRTUAL_WIDTH then
    self.backgroundX = 0
  end

  for i, bush in ipairs(self.bushes) do
    bush.x = bush.x - self.scrollSpeed * dt
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
    coin.x = coin.x - self.scrollSpeed * dt
    if coin.x + coin.width < 0 then
      coin.inPlay = false
    end
    if coin:collides(self.player) then
      gSounds["pickup"]:play()
      coin.inPlay = false
      gScore["current"] = gScore["current"] + coin.points
      self.spawnScore = self.spawnScore + coin.points
      self:checkScore()
    end
  end

  for i, coin in ipairs(self.coins) do
    if not coin.inPlay then
      table.remove(self.coins, i)
    end
  end

  for i, creature in ipairs(self.creatures) do
    creature:update(dt)
    creature.x = creature.x - self.scrollSpeed * 1.5 * dt
    if creature.x + creature.width < 0 then
      creature.inPlay = false
      gScore["current"] = gScore["current"] + creature.points
      self.spawnScore = self.spawnScore + creature.points
      self:checkScore()
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

function ScrollState:checkScore()
  if self.spawnScore >= INCREMENT_THRESHOLD then
    self.spawnScore = 0
    self.scrollSpeed = math.min(SCROLL_SPEED * 2, self.scrollSpeed + INCREMENT_SCROLL_SPEED)
    self.spawnOdds = math.max(math.floor(SPAWN_ODDS / 2), self.spawnOdds - INCREMENT_SPAWN_ODDS)
  end
end

function ScrollState:render()
  love.graphics.translate(-self.backgroundX, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][gBackgroundVariant], 0, 0)
  love.graphics.draw(gTextures["backgrounds"], gQuads["backgrounds"][gBackgroundVariant], VIRTUAL_WIDTH, 0)
  love.graphics.translate(self.backgroundX, 0)

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
