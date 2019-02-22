include <cornucopia/util/constants.scad>

// Convert to and from degrees and radians.
deg = 180.0 / pi;
function deg_to_rad(angle) = angle * (1 / deg);
function rad_to_deg(angle) = angle * deg;

// Rescale an object with respect to a point of reference.
module local_scale(factor, reference=[0, 0, 0]) {
    translate(-reference) scale(factor) translate(reference) children(0);
}
