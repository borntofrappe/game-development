# Animation

[CS50's Intro to Game Development](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz) introduces a small library to manage frame by frame animation. The goal of this folder is to try and replicate the library with my own code.

## Notes

The animation library works by describing a table of frames and an interval.

```lua
dogAnimation = Animation:new(
  {1,2,3},
  0.2
)
```

The idea is to set up a timer, keep track of delta time and when the timer exceeds the input interval, cycle through the table.

```lua
function Animation:new(frames, interval)
  local this = {
    ["frames"] = frames,
    ["interval"] = interval,
    ["timer"] = 0,
    ["currentFrame"] = 1
  }
end
```

`index` is updated to describe the index in the `frames` array.

The `update` function updates this value when `timer` exceeds the input `interval`.

```lua
if self.index == #self.frames then
  self.index = 1
else
  self.index = self.index + 1
end
```

The `getCurrentFrame` function returns the frame at the current index.

```lua
return self.frames[self.index]
```

## Demo

`main.lua` demos the library with two animations: one looping indefinitely in the bottom right corner and one running only when the `down` arrow key is continuously being pressed.
