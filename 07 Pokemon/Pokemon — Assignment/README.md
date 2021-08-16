# Pokemon — Assignment

The assignment asks to provide an interface to shows the change in the stats of a pokemon as it levels up. This is relevant as the player pokemon gains experience, and eventually reaches the `expToLevel` threshold, in `BattleTurnState`.

## Planning

Instead of showing a single textbox, I decided to rely on the logic of `BattleMessageState`. This one provides an interface in which a textbox is automatically updated, and it is therefore possible to implement the feature as follows:

- build a table collecting the increments for the different statistics in `Pokemon:levelUp()`

- have the `levelUp` function return the table, so that `BattleTurnState` is able to know how the statistics have changed

- build a table of strings, showing for each statistic the following format

  ```text
  STAT: PREVIOUS_VALUE + INCREMENT = CURRENT_VALUE
  ```

- pass the table of string to an instance of `BattleMessageState`

The individual state is then already equipped to show the text. What changes is that the callback function popping the player back to the field needs to consider an additional layer, and an additional `pop` operation.

## levelUp

The `levelUp` function is responsible for changing the stats in `self.baseStats` and `self.Stats` tables (remember that the health points need to change in their maximum value, and therefore in the first table).

To collect the increments achieved in the logic of the for loop, I decided to build a table `increments`, and describe the value for each stat. `0` by default, `1` in the moment the dice roll identifies an increase.

The first plan was to use a table in which the name of the statistic would be used as a key.

```lua
increments = {}
for k, IV in pairs(self.IVs) do
  increments[k] = 0
  -- change if necessary
end
```

While this works, it is important to remember that the `pairs` iterator doesn't guarantee that the stats are shown in order (health, followed by attack, defense and eventually speed). To this end, I decided to start from a table describing the name of the stats, and in the desired configuration.

```lua
local stats = {"hp", "attack", "defense", "speed"}
```

The `increments` table then uses a counter variable as a key.

```lua
local increments = {}
for i = 1, #stats do
  increments[i] = {
    ["stat"] = stats[i],
    ["value"] = 0
  }

  -- roll dice
end
```

In this manner, the table of increments shows the change as follows:

```lua
increments = {
  [1] = {
    ["stat"] = "hp",
    ["value"] = 0
  },
  [2] = {
    ["stat"] = "attack",
    ["value"] = 0
  },
  [3] = {
    ["stat"] = "defense",
    ["value"] = 0
  },
  [4] = {
    ["stat"] = "speed",
    ["value"] = 0
  },
}
```

And with this structure, the `ipairs` iterator is able to loop through the stats in order.

```lua
for i, increment in ipairs(increments) do
  print(increment.stat .. ' = ' .. increment.value)
end
--[[
  hp = 0
  attack = 0
  defense = 0
  speed = 0
]]
```

## Message

With the increments provided in the table as described in the previous section, all that is necessary is to build a table in the format "X + Y = Z".

Ultimately, I opted to incorporate the uppercase version of the stat, and as follows:

```lua
stat:upper() .. ": " .. valueStat - valueIncrement .. " + " .. valueIncrement .. " = " .. valueStat
```

This concatenation sequence allows to print, taking for instance the `hp` stat for the pokemon aardart, the following:

```text
HP: 14 + 1 = 15
```

The logic is repeated for every statistic received from the `levelUp` function, and the strings are collected in a table.

```lua
local levelUpIncrements = self.player.pokemon:levelUp()
local levelUpMessage = {}

for i, levelUpIncrement in ipairs(levelUpIncrements) do
end
```

Notice the use of the `ipairs` iterator. As detailed in the previous section, it guarantees the order detailed in the table through the counter variable.

The table is finally used in an instance of `BattleMessageState`, which allows the game to show the formula, stat after stat.

_Please note_: the value obtained from `self.pokemon` already contains the increment. This explains why the increment is subtracted to show the previous numerical value.

_Please also note_: the reference for the health points is to the `baseStat` table, and not to the `stats` counterpart. This was explained in a previous update, and relates to how `baseStat.hp` is used for the width of the progress bar, as the maximum value of the `hp` stat.

```lua
local valueStat = stat == "hp" and self.player.pokemon.baseStats[stat] or self.player.pokemon.stats[stat]
```
