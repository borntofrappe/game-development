# Character

With the scrolling of the camera implemented, the character is drawn through the image found in **character.png**. The file describes multiple versions of the characters, multiple stances actually. The idea is to use the different versions to animate the character, as it moves, jumps and reacts to the surrounding environment.

## Update 0 - character.lua

With the first update the application is updated to include the character.

This allows to practice once more with the quad function and most prominently with the coordinate system of Love2D. Indeed the character needs to be included atop the tiles making up the ground, and this is achieved by placing in a variable the number of tiles making up the sky.

After a bit of experimentation and taking stock of the lessons learned with SVG syntax, including the character at the desired vertical coordinate is a matter of acknowledging how the tiles and the character are drawn top to bottom, left to right.

# Update 1 - moving.lua

The second update allows to move the character left and right. This is achieved much alike the camera scroll, through a constant variable describing the speed and a cumuative variable changing the `x` coordinate of the shape being drawn.

I decided to take the concept a bit further and already include a small animation, by changing the quad being drawn in the page, but that will be covered in a later update. I started by including separate variables, and then create a table centralizing all the values held by the character. In the end it might be best to have a separate class, `Character`, which handles the entire logic through proprietary values.
