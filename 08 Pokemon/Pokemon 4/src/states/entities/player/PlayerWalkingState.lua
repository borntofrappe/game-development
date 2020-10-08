PlayerWalkingState = Class({__includes = BaseState})

function PlayerWalkingState:init(player)
  self.player = player
  self.animation = Animation({["frames"] = {1, 2, 3}, ["interval"] = 0.1})
  self.player.currentAnimation = self.animation
  self.isMoving = false
end

function PlayerWalkingState:update(dt)
  self.player.currentAnimation:update(dt)

  if not self.isMoving then
    self.isMoving = true
    if self.player.direction == "up" then
      self.player.row = math.max(1, self.player.row - 1)
    elseif self.player.direction == "right" then
      self.player.column = math.min(COLUMNS, self.player.column + 1)
    elseif self.player.direction == "down" then
      self.player.row = math.min(ROWS, self.player.row + 1)
    elseif self.player.direction == "left" then
      self.player.column = math.max(1, self.player.column - 1)
    end

    Timer.tween(
      0.4,
      {
        [self.player] = {x = (self.player.column - 1) * TILE_SIZE, y = (self.player.row - 1) * TILE_SIZE}
      }
    ):finish(
      function()
        if love.keyboard.isDown("up") then
          self.player.direction = "up"
          self.player:changeState("walking")
        elseif love.keyboard.isDown("right") then
          self.player.direction = "right"
          self.player:changeState("walking")
        elseif love.keyboard.isDown("down") then
          self.player.direction = "down"
          self.player:changeState("walking")
        elseif love.keyboard.isDown("left") then
          self.player.direction = "left"
          self.player:changeState("walking")
        else
          self.player:changeState("idle")
        end
      end
    )
  end
end
