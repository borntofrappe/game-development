PlayState = Class {__includes = BaseState}

function PlayState:enter(params)
  self.player = params.player
  self.asteroids = params.asteroids
end

function PlayState:update(dt)
  if love.keyboard.wasPressed("escape") then
    gStateMachine:change("title")
  end

  for k, asteroid in pairs(self.asteroids) do
    asteroid:update(dt)

    if self.player:collides(asteroid) then
      self.player:reset()
      local x = asteroid.x
      local y = asteroid.y
      local speed = asteroid.speed
      local type = asteroid.type
      if type > 1 then
        table.insert(self.asteroids, Asteroid(x, y, type - 1, speed))
        table.insert(self.asteroids, Asteroid(x, y, type - 1, speed))
      end
      table.remove(self.asteroids, k)

      gStateMachine:change(
        "spawn",
        {
          player = self.player,
          asteroids = self.asteroids
        }
      )
    end
  end

  self.player:update(dt)
end

function PlayState:render()
  for k, asteroid in pairs(self.asteroids) do
    asteroid:render()
  end

  self.player:render()
end
