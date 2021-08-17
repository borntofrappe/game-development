# Pokemon 11

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

## Battle

The battle is represented by multiple states:

- `BattleState` introduces the battle, with a dialogue describing the opposing and player's pokemon

- `BattleMenuState` shows the selection, with the options to fight and run

- `BattleMessageState` shows a textbox and automatically loops through the chunks using `Timer.every`

- `BattleTurnState` is responsible for updating the pokemon stats, modifying the health points and soon managing a victory and defeat

## callbacks

After the battle state, each individual state defines a function through `self.callback`. By default the callback pops the state from the stack, but can be optionally modified by the code invoking the state.

```lua
self.callback = def.callback or function()
  gStateStack:pop()
end
```

For instance and considering when the player selects the option `Run`, the default pop operation is replaced by a callback which pops two states in a row.

```lua
gStateStack:push(
  BattleMenuState(
    {
      ["callback"] = function()
        gStateStack:pop()
        gStateStack:pop()
      end,
      -- other attributes
    }
  )
)
```

Twice to have the stack remove the battle states and revert to the `PlayState`.
