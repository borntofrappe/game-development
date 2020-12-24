Add experience, react to a pokemon reaching zero health points.

## Experience

In the `Pokemon` class, three variables are initialized to implement the experience feature: `level`, `exp` and `expToLevel`. The idea is to have `exp` keep track of the experience accumulated in the battles, and reset the value when reaching the threshold described by `expToLevel`. All the while, `level` is used to compute the `expToLevel` threshold.

```lua
self.level = 5
self.exp = 0
self.expToLevel = math.floor(self.level * self.level * 0.75)
```

Remember to use the level of the pokemons in the play state, instead of the previously hard-coded `Lv 5`.

```lua
love.graphics.print(
  "LV " .. self.wildPokemon.level,
  -- other attributes
)
```

Experience is added in the `BattleTurnState`, more on this later, and ultimately allows to level up through the `levelUp` function. This is defined on the pokemon class, to increment the level and re-compute the threshold.

```lua
function Pokemon:levelUp()
  self.level = self.level + 1
  self.exp = 0
  self.expToLevel = math.floor(self.level * self.level * 0.75)
end
```

The function is responsible for also updating the stats, but this will be discussed later in the `IVs` section.

## Progress bar

The GUI responsible for the player's pokemon's experience is updated to use the variables introduced in the previous section.

```lua
ProgressBar(
  {
    -- previous attributes
    ["value"] = self.player.pokemon.exp,
    ["max"] = self.player.pokemon.expToLevel
  }
)
```

The GUI is then passed to `BattleTurnState`, so that the state is able to change its value as the wild pokemon is defeated.

```lua
BattleTurnState(
  {
    -- previous attributes
    ["pExp"] = self.playerPokemonExp
  }
)
```

The state receives also the instance of the `Player` class.

```lua
BattleTurnState(
  {
    -- previous attributes
    ["player"] = self.player,
    ["pExp"] = self.playerPokemonExp
  }
)
```

This value is necessary since `BattleTurnState` doesn't know which pokemon represents the player's creature. Out of convenience, the state receives `p1` and `p2` in the order in which the pokemons attack (based on their speed).

## Victory and loss

In `BattleTurnState`, the idea is to check the health points of each creature after the `tween` animation modifying the health bar.

```lua
Timer.tween():finish(
  function()
    if self.p2.stats.hp == 0 then
      self:checkSide(self.p2)
    else
      self.callback()
    end
  end
)
```

The same operation is repeated for the second player, as the damage is inflicted on its side. In both occasions, the `self:checkSide` function receives the pokemon being defeated.

```lua
function BattleTurnState:checkSide(p)

end
```

Comparing then the pokemon against the player's creature, the function updates the stack in two different ways:

- if the player's pokemon is defeated, show a dialogue detailing `You fainted`.

  ```lua
  gStateStack:push(
    DialogueState(
      {
        ["chunks"] = {"You fainted."},
        -- other attributes
      }
    )
  ```

  Following the dialogue, move back to the play state (with a fading transition omitted for convenience).

  ```lua
  ["callback"] = function()
    gStateStack:pop()
    gStateStack:pop()
    gStateStack:pop()
    self.callback()
  end
  ```

  Ultimately, push another dialogue describing how the pokemon has been healed

  ```lua
  self.player.pokemon.stats.hp = self.player.pokemon.baseStats.hp
    gStateStack:push(
      DialogueState(
        {
          ["chunks"] = {"Your pokemon has been healed.\nTry again."}
        }
      )
    )
  ```

- if the wild pokemon is defeated, show a dialogue prompting `Victory!`.

  ```lua
  gStateStack:push(
    DialogueState(
      {
        ["chunks"] = {"Victory!"},
        -- other attributes
      }
    )
  ```

  As the player dismisses the dialogue, show a message with the experience gained, and further consider the experience gained.

  ```lua
  ["callback"] = function()
    local exp = math.random(5, 15)
  end
  ```

  Show a message detailing how the experience is increased.

  ```lua
  gStateStack:push(
    BattleMessageState(
      {
        ["chunks"] = {"You earned " .. exp .. " experience points!"}
      }
    )
  ```

  Finally, increase the experience and compare the value against the threshold.

  ```lua
  self.player.pokemon.exp = math.min(self.player.pokemon.exp + exp, self.player.pokemon.expToLevel)
  self.pExp:setValue(self.player.pokemon.exp)
  ```

  - if the experience matches the threshold, show another message describing `Congratulations! Level up!`, right after calling the `levelUp` function.

    ```lua
    gStateStack:push(
    BattleMessageState(
      {
        ["chunks"] = {"Congratulations! Level up!"}
      }
    )
    ```

    As the message is dismissed, move to the play state with a fading transition

  - else, move directly to the play state with a fading transition

## IVs

The idea is to loop through the stats described in the `IVs` table, and for each stat emulate a dice roll three times.

```lua
for k, IV in pairs(self.IVs) do
  for i = 1, 3 do
    local diceRoll = math.random(1, 6)
  end
end
```

If the individual value exceeds the dice roll, the matching stat is incremented.

```lua
if IV > diceRoll then
  self.stats[k] = self.stats[k] + 1
  break
end
```

The `break` statement is to break out the for loop rolling the dice, so that the game can continue with the other stats, or ultimately terminate the function.

### Update

Incrementing the stats work for the attack, defense and speed values, but not for the health points `hp`. In this instance, the idea is to increment the base value, so that the pokemon has a higher maximum value for its health.

```lua
if IV > diceRoll then
  if k == "hp" then
    self.baseStats[k] = self.baseStats[k] + 1
  else
    self.stats[k] = self.stats[k] + 1
  end
  break
end
```
