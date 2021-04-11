The images and the inkscape file must follow the following conventions to make Chukinas.Dreadnought.Spritesheet compile correctly.

IMAGE SIZE
Image size is dictated by the scaling in the SVG file, so the size of the actual image doesn't matter.

IMAGE FILE NAME
This dictates the function names in Spritesheet.
Example: To access the "small_ship" in the "red1.png" file:
Spritesheet.red1("small_ship")

INKSCAPE LAYERS

Each layer contains all the data for a single spritesheet.

Its name should match the filename (minus extension). This is just for readability, as the Spritesheet macro pulls from the filename itself.
Example: "red1.png"'s layer should be called "red1"

INKSCAPE SUBLAYERS

Each sublayer (w/in a layer) ...
