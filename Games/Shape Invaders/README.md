Recreate the popular game _Space Invaders_ with regular shapes.

## Gameplay

As the title implies, the game is centered on regular shapes. You are tasked to destroy a squadron of equilateral triangles, circles and squares. The squadron is composed of rows of each shape, and the rows stagger horizontally and vertically colliding with the edge of the window.

## Update 0 — title

Using a state machine and the `timer` module from the **knife** library, render a screen with the title, above a basic instruction on how to proceed. Use different font sizes and colors.

The animation has several layers:

- scroll the title from the bottom of the window

- have the instruction appear and disappear, as if blinking. This blink is actually achieved with a `Timer.every` function, which nests a `Timer.after`.
