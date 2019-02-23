include <cornucopia/util/constants.scad>

// Convert to and from degrees and radians.
deg = 180.0 / pi;
function degToRad(angle) = angle * (1 / deg);
function radToDeg(angle) = angle * deg;

// Rescale an object with respect to a point of reference.
module localScale(factor, reference=[0, 0, 0]) {
    translate(-reference) scale(factor) translate(reference) children(0);
}

module testMath() {
    echo(testApproximately("37.3 degrees to radians", degToRad(37.3), 0.6510078));
    echo(testApproximately("1.34 radians to degrees", radToDeg(1.34), 76.77634));
}
