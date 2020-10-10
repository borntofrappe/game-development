Introduce GUIs.

The update is devoted to the design of the GUIs elements, from the most simple panel (a rectangle with an outline and a solid background), and ending with a selection (showing a cursor with two possible options).

_Be warned_: the functionality associated with the GUIs is mostly the subject of a future update.

## GUI

In the `src/gui` folder you find different `.lua` files describing the graphical user interfaces used throughout the game. These are used throughout the game in the individual states:

- `Panel` renders a rectangle with an outline and a solid border

- `TextBox` uses a panel and renders text above the solid background

- `ProgressBar` renders a filled rectangle of a given color and a width dependent on the input percentage

- `Selection` renders a list of options next to the image of a cursor

### Default values

Much of the complexity from the `:init` functions is due to the fact that each interface is given a set of fallback values. The panel, for instance, includes a rectangle at the top of the window, while the textbox shows an arbitrary string. In the `init` function the game accommodates for a situation in which to field is passed at all, and by setting up a default value for the input table.

```lua
function Panel:init(def)
  local def = def or {}
end
```
