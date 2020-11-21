Player = Particle:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, PLAYER_RADIUS)

function Player:grow(r)
  Timer:tween(
    0.2,
    {
      [self] = {["r"] = self.r + r}
    }
  )
end
