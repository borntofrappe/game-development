# Timer 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The script updates the interval through two variables:

- `counter`, to consider delta time as received from the `love.update(dt)` function

- `seconds`, to consider the number of seconds with an integer

`counter` is incremented by `dt` every time the game loop runs. When `counter` crosses the threshold of `1` second, it is reset back to `0` — actually to the excess above the `1` second — and `seconds` is incremented by one.

```lua
function love.update(dt)
  counter = counter + dt
  if counter > 1 then
    counter = counter % 1
    seconds = seconds + 1
  end
end
```
