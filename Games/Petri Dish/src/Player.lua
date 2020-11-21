Player =
  Particle:new(
  0,
  0,
  PLAYER_RADIUS,
  {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1
  }
)

function Player:assimilate(particle)
  for i, tween in ipairs(Timer.tweens) do
    if tween.label == "assimilate" then
      table.remove(Timer.tweens, i)
    end
  end

  local area = math.pi * self.r ^ 2 + math.pi * particle.r ^ 2
  local r = (area / math.pi) ^ 0.5

  local color = particle.color
  Timer:tween(
    0.2,
    {
      [self] = {["r"] = r},
      [self.color] = {
        ["r"] = color.r,
        ["g"] = color.g,
        ["b"] = color.b
      }
    },
    "assimilate"
  )
end
