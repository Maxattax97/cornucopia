include <cornucopia/util/constants.scad>

// Rescale an object with respect to a point of reference.
module MTH_localScale(factor, reference=[0, 0, 0]) {
    translate(-reference) scale(factor) translate(reference) children(0);
}

module testMath() {
    echo("Currently no tests for MTH module.");
}
