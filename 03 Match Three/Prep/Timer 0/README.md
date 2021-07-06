# Timer 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The script counts the number of seconds through two variables:

- `timer`, to consider the passage of time as detailed by the `dt` argument from `love.update(dt)`

- `seconds`, to consider the number of seconds with an integer

`timer` is incremented by `dt` every time the game loop runs. When `timer` crosses the threshold of `1` second, it is reset back to `0` — actually to the excess above the `1` second — and `seconds` is incremented by one.

```lua
function love.update(dt)
  timer = timer + dt
  if timer > 1 then
    timer = timer % 1
    seconds = seconds + 1
  end
end
```
