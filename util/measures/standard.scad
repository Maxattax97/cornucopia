
MM = 1.0;

X = [ 1, 0, 0 ];
Y = [ 0, 1, 0 ];
Z = [ 0, 0, 1 ];
ORIGIN = [ 0, 0, 0 ];

// Useful for small distances to maintain manifold geometry.
EPSILON = 0.01 * MM;
OS = EPSILON;

// Various drawing resolution for different standard qualities.
RESOLUTION_DRAFT = 6;
RESOLUTION_PROTOTYPE = 12;
RESOLUTION_PRODUCTION = 24;
$fn = RESOLUTION_PROTOTYPE;

// Convert to and from degrees and radians.
RAD = 1.0;
DEG = 180.0 / PI;
function MSR_degToRad(angle) = angle * (1 / DEG);
function MSR_radToDeg(angle) = angle * DEG;

module
testStandard()
{
    echo(TST_equal(
        "Singling out X component", X * [ 34.3, 923.4, -203.1 ], 34.3));
    echo(TST_equal("Adding some epsilon to origin's Z",
                   EPSILON * Z + ORIGIN,
                   [ 0, 0, EPSILON ]));
    echo(TST_approximately(
        "37.3 degrees to radians", MSR_degToRad(37.3), 0.6510078));
    echo(TST_approximately(
        "1.34 radians to degrees", MSR_radToDeg(1.34), 76.77634));
}
