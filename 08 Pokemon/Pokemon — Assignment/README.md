# [Assignment](https://docs.cs50.net/ocw/games/assignments/7/assignment7.html)

> Implement a `Menu` that appears during the player Pokémon’s level up that shows, for each stat, ‘X + Y = Z’, where X is the starting stat, Y is the amount it’s increased for this level, and Z is the resultant sum. This `Menu` should appear right after the “Level Up” dialogue that appears at the end of a victory where the player has indeed leveled up.

The way I implemented the logic increasing the stats is different from the one proposed by the lectuter. In particular, `Pokemon:levelUp` increases the stats by looping through the `IVs` table and modifying directly the associated values.

```lua
for k, IV in pairs(self.IVs) do
  for i = 1, 3 do
    local diceRoll = math.random(1, 6)
    if IV > diceRoll then
      if k == "hp" then
        self.baseStats[k] = self.baseStats[k] + 1
      else
        self.stats[k] = self.stats[k] + 1
      end
      break
    end
  end
end
```

The function doesn't return the stats' increase, which means the logic needs to be slightly modified.

Once implemented, `BattleTurnState` receives the increments.

```lua
increments = self.player.pokemon:levelUp()
```

I am still uncertain as to how the increments should be returned, whether individually or in a table. Instead of showing a `Menu` however, I see it fit to use the `TextBox` GUI as provided by the `BattleMessageState`. The textbox is able to stretch in height, and the state allows to directly move to the play state once the GUI is dismissed.
