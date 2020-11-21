# Petri Dish

The goal is to create a game inspired by [agar.io](https://en.wikipedia.org/wiki/Agar.io), where a large cell assimilates neighboring, smaller units by entering into contact with them.

Using `love.math.noise` then, the goal is to animate the cell to draw a circle, and show a blob-like animation every time a contact is registered.

## Noise

In the `Noise` folder I explore `love.math.noise` with the ultimate goal of building the foundation for the blob-like animation. The folder works as a spiritual successor to `Lunar Lander/Noise`, and discusses noise functions with two arguments.

## Timer

In the `Timer` folder I try to recreate the functionality of the knife library, in order to manage a delay, interval, and ultimately tween animation. This last function is especially useful to modify the size of the blob in the final game.

## Resources

- [Wikipedia entry for agar.io](https://en.wikipedia.org/wiki/Agar.io)

- [Coding Train on agar.io](https://thecodingtrain.com/CodingChallenges/032.1-agar.html)

- [Coding Train on blobs created with noise](https://thecodingtrain.com/CodingChallenges/036-blobby)

- fix translation
- fix gameplay: radius, area and scale
- animate blob
  - add noise
  - animate offset for a full rotation
  - remove noise
