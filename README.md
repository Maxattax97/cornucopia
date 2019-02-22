# Cornucopia
A plethora of OpenSCAD modules, utilities, and constants for engineering real solutions in CAD.

## Description

As I began learning OpenSCAD, I found it frustrating that there was a lack of _standard_ parts in the ecosystem. MCAD was a great resource, but the documentation was lacking, and it was starting to become out of date. I looked into parts designed by other people, but these are scattered widely and are seemingly inconsistent in design.

This repository aims to fix all of these issues and more.

## Usage

To utilize Cornucopia in your projects, simply clone this repository into your OpenSCAD library path. Afterward, `use <cornucopia/folder/file.scad>`, or alternatively ``use <cornucopia/folder/all.scad>`` to import with wildcard functionality. Wildcards only include `.scad` files from *within that directory* and do not import children recursively, just as in Java.

We are currently using [McMaster-Carr's](https://www.mcmaster.com/) catalog as an outline for the file structure. For electrical components, try to follow [Digi-Key's](https://www.digikey.com/) catalog under the `/electrical/` folder.

## Tests and Formatting

A small amount of unit testing is performed on code, mostly for syntactical correctness. In addition, all code is formatted to maintain readability.

``
make wildcard   # This generates the all.scad wildcard files for each directory.
make test       # This will perform checks on all source files.
make fix        # This will format all source files.
make            # Does all of the above in one fell swoop.
``

## Contributing

Add your `.scad` files to an appropriate folder or subfolder (create one if you feel a new category is ideal). Add it to the appropriate `all.scad` wildcard file. Make a pull request.
