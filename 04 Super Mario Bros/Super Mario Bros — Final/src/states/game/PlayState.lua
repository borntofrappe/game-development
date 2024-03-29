PlayState = Class({__includes = BaseState})

function PlayState:init()
  self.width = 100
  self.height = 10
  self.level = LevelMaker.generate(self.width, self.height)

  self.background = math.random(#gFrames.backgrounds)

  self.camX = 0

  self.player =
    Player(
    {
      x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2,
      y = TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT,
      width = PLAYER_WIDTH,
      height = PLAYER_HEIGHT,
      texture = "character",
      stateMachine = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ["walking"] = function()
            return PlayerWalkingState(self.player)
          end,
          ["jump"] = function()
            return PlayerJumpState(self.player)
          end,
          ["falling"] = function()
            return PlayerFallingState(self.player)
          end
        }
      ),
      level = self.level
    }
  )

  self.player:changeState("idle")

  self:addCreaturesState()
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("start")
  end

  self.player:update(dt)

  self.level:update(dt)

  self.camX =
    math.max(
    0,
    math.min(self.width * TILE_SIZE - VIRTUAL_WIDTH, self.player.x + self.player.width / 2 - VIRTUAL_WIDTH / 2)
  )

  if self.player.x <= 0 then
    self.player.x = 0
  elseif self.player.x >= self.width * TILE_SIZE - self.player.width then
    self.player.x = self.width * TILE_SIZE - self.player.width
  end
end

function PlayState:render()
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)

  love.graphics.setFont(gFonts["medium"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print("Score: " .. self.player.score, 4 + 1, 4 + 1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Score: " .. self.player.score, 4, 4)
  love.graphics.translate(-math.floor(self.camX), 0)

  self.level:render()

  self.player:render()
end

function PlayState:addCreaturesState()
  for k, entity in pairs(self.level.entities) do
    entity.stateMachine =
      StateMachine(
      {
        ["idle"] = function()
          return CreatureIdleState(self.player, entity)
        end,
        ["moving"] = function()
          return CreatureMovingState(self.level.tileMap, self.player, entity)
        end,
        ["chasing"] = function()
          return CreatureChasingState(self.level.tileMap, self.player, entity)
        end,
        ["stucked"] = function()
          return CreatureStuckedState(self.player, entity)
        end
      }
    )

    entity:changeState("idle")
  end
end
