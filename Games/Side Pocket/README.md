# Side Pocket

With this project I set out to create a basic game of pool, or billiard, leveraging the physics library Box2D.

## Style

The game has but one state, in which an infinite game of pool is played in the bottom half. The top half is instead reserved to two panels respectively showing a launcher and the ball already being pocketed.

### Launcher

The component describes a circle positioned inside a rounded rectangle.

<svg viewBox="-2 -2 100 20" width="200" height="40">
  <rect rx="8" width="96" height="16" fill="none" stroke="hsl(0, 0%, 30%)" stroke-width="2" />
  <circle fill="hsl(0, 0%, 30%)" cx="8" cy="8" r="6" />
</svg>

The idea is to have the circle move following a particular key press, for instance on the space bar, and continuously bounce from end to end.

<svg viewBox="-2 -2 100 20" width="200" height="40">
  <rect rx="8" width="96" height="16" fill="none" stroke="hsl(0, 0%, 30%)" stroke-width="2" />
  <circle opacity="0.2" fill="hsl(0, 0%, 30%)" cx="64" cy="8" r="6" />
  <circle opacity="0.4" fill="hsl(0, 0%, 30%)" cx="66" cy="8" r="6" />
  <circle fill="hsl(0, 0%, 30%)" cx="68" cy="8" r="6" />
</svg>

As the same key is pressed once more, the component finally computes the speed considering the percentage covered in the rectangle.

<svg viewBox="-2 -2 100 20" width="200" height="40">
  <rect rx="8" width="96" height="16" fill="none" stroke="hsl(0, 0%, 30%)" stroke-width="2" />
  <circle fill="hsl(0, 0%, 30%)" cx="68" cy="8" r="6" />
  <text font-size="9" x="75" y="11.5">70%</text>
</svg>

This covers the interaction behind the launcher, but in terms of style, the idea is to also provide a signifier, a helper graphic above the rounded rectangle. This signifier might describe the purpose of the component with two strings, `min` and `max`, as well as a series of rectangles of increasing height.

<svg viewBox="0 0 80 20" width="200" height="50">
  <g fill="hsl(0, 0%, 30%)">
    <g font-size="9" style="text-transform:uppercase;">
      <text  x="5" y="15">Min</text>
      <text  x="75" y="15" text-anchor="end">Max</text>
    </g>
    <g transform="translate(0 15) scale(1 -1)">
      <rect rx="2" x="28" width="4" height="4" />
      <rect rx="2" x="34" width="4" height="6" />
      <rect rx="2" x="40" width="4" height="8" />
      <rect rx="2" x="46" width="4" height="10" />
      <rect rx="2" x="46" width="4" height="10" />
    </g>
  </g>
</svg>

### Pocketed

The component describes, always in a rounded rectangle, the balls already pocketed in the game. It does so maintaining the order in which the balls are eliminated and by highlighting the corresponding number.

<svg viewBox="-2 -2 100 50" width="200" height="100">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect rx="8" width="96" height="46" stroke-width="2" />
    <circle cx="11" cy="11" r="6" />
    <circle cx="27" cy="11" r="6" />
    <circle cx="43" cy="11" r="6" />
  </g>
  <g fill="hsl(0, 0%, 30%)" font-weight="bold">
    <text font-size="10" x="10.75" y="14.75" text-anchor="middle">6</text>
    <text font-size="10" x="26.75" y="14.75" text-anchor="middle">2</text>
    <text font-size="10" x="42.75" y="14.75" text-anchor="middle">3</text>
  </g>
</svg>

### Surface

_Please note_: I use "surface" instead of "table" as I found the noun would be at odds with the "table" used by Lua to describe the data structure.

This is the essence of the game, and where box2d creates the physics-based simulation.

Box2D itself is set to create the surface with a rectangle, and six circles making up the pockets.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
</svg>

With `love.graphics` then, the idea is to enhance the previous structure with a more pleasing aesthetic. `love.graphics.rectangle` can, for instance, include a rectangle with rounded borders, to match with the overall style.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
    <rect x="-2.5" y="-2.5" width="105" height="55" stroke-width="5" rx="5" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
</svg>

### Balls

In the context of the surface, the game finally populates the level with a predetermined number of balls.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
    <rect x="-2.5" y="-2.5" width="105" height="55" stroke-width="5" rx="5" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
  <g>
    <circle stroke="hsl(0, 0%, 0%)" stroke-width="0.75" fill="none" r="2.5" cx="75" cy="27.5"/>
    <circle fill="hsl(0, 70%, 60%)" r="2.5" cx="30" cy="27.5"/>
    <circle fill="hsl(45, 70%, 80%)" r="2.5" cx="25" cy="25"/>
    <circle fill="hsl(120, 70%, 70%)" r="2.5" cx="25" cy="30"/>
    <circle fill="hsl(180, 70%, 80%)" r="2.5" cx="20" cy="22.5"/>
    <circle fill="hsl(240, 70%, 60%)" r="2.5" cx="20" cy="27.5"/>
    <circle fill="hsl(300, 70%, 60%)" r="2.5" cx="20" cy="32.5"/>
  </g>
</svg>

The colors chosen in the graphic are purely experimental, but ultimately showcase how to differentiate between the ball controlled by the player and the targets of the game.

_Please note_: one of the game's feature is that the balls can be toggled between ball and number.

<svg viewBox="-5 -5 110 60" width="275" height="150">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
    <rect x="-2.5" y="-2.5" width="105" height="55" stroke-width="5" rx="5" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
  <g>
    <circle stroke="hsl(0, 0%, 0%)" stroke-width="0.75" fill="none" r="2.5" cx="75" cy="27.5"/>
    <circle stroke="hsl(0, 70%, 60%)" fill="none" r="2.5" cx="30" cy="27.5"/>
    <circle stroke="hsl(45, 70%, 80%)" fill="none" r="2.5" cx="25" cy="25"/>
    <circle stroke="hsl(120, 70%, 70%)" fill="none" r="2.5" cx="25" cy="30"/>
    <circle stroke="hsl(180, 70%, 80%)" fill="none" r="2.5" cx="20" cy="22.5"/>
    <circle stroke="hsl(240, 70%, 60%)" fill="none" r="2.5" cx="20" cy="27.5"/>
    <circle stroke="hsl(300, 70%, 60%)" fill="none" r="2.5" cx="20" cy="32.5"/>
  </g>
  <g font-size="4" font-weight="bold" text-anchor="middle">
    <text x="30" y="29">1</text>
    <text x="25" y="27">2</text>
    <text x="25" y="31.5">3</text>
  </g>
</svg>

## Development

`Launcher` makes use of two utilities: `Panel` and `Slider`. The first one is responsible for rendering the outline of a rounded rectangle. The second for rendering a panel and a circle bouncing within the panel itself.
