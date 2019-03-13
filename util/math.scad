include <cornucopia/util/constants.scad>
include <cornucopia/util/measures/standard.scad>
/**
 * Computes the exponent of a base and a power.
 * @param base The number to be multiplied power times.
 * @param power The number of times to multiply the base together.
 * @return The base risen the the power.
 */
function MTH_power(base, power) = pow(base, power);
// exp(ln(base) * power);

/**
 * Measures the distance between two 3D vectors.
 * @param vector_a The first 3D vector to compare.
 * @param vector_b The second 3D vector to compare.
 * @return The distance between vector_a and vector_b.
 */
function MTH_distance3D(vector_a, vector_b) =
    sqrt((vector_a[0] - vector_b[0]) * (vector_a[0] - vector_b[0]) +
         (vector_a[1] - vector_b[1]) * (vector_a[1] - vector_b[1]) +
         (vector_a[2] - vector_b[2]) * (vector_a[2] - vector_b[2]));

/**
 * Measures the distance between two 2D vectors.
 * @param vector_a The first 2D vector to compare.
 * @param vector_b The second 2D vector to compare.
 * @return The distance between vector_a and vector_b.
 */
function MTH_distance2D(vector_a, vector_b) =
    sqrt((vector_a[0] - vector_b[0]) * (vector_a[0] - vector_b[0]) +
         (vector_a[1] - vector_b[1]) * (vector_a[1] - vector_b[1]));

/**
 * Measures the distance between two 1D values.
 * @param vector_a The first value to compare.
 * @param vector_b The second value to compare.
 * @return The distance between vector_a and vector_b.
 */
function MTH_distance1D(vector_a, vector_b) = abs(vector_a - vector_b);

/**
 * Normalizes a vector such that it's length is equal to 1, but maintains its
 * direction.
 * @param vector The vector to be normalized.
 * @return A vector of length 1 with the same direction.
 */
function MTH_normalize(vector) = norm(vector);
// vector / (max(MTH_distance3D(ORIGIN, vector), EPSILON));

/**
 * Calculates the 3D orientation of a normalized vector.
 * @param vector The vector to be examined.
 * @return The 3D orientation of the normalized vector.
 */
function MTH_normalVectorAngle(vector) = [
    0,
    -1 * atan2(vector[2], MTH_distance1D([ vector[0], vector[1] ])),
    atan2(vector[1], vector[0])
];

/**
 * Calculates the 3D orientation of a vector.
 * @param The vector to be examined.
 * @return The 3D orientation of the vector in degrees.
 */
function MTH_vectorAngle(vector) = MTH_normalVectorAngle(MTH_normalize(vector));

/**
 * Calculates the angle between two vectors.
 * @param vector_a The first vector to be examined.
 * @param vector_b The second vector to be examined.
 * @return The 3D angle between vectors in degrees.
 */
function MTH_vectorAngleBetween(vector_a, vector_b) =
    MTH_vectorAngle(MTH_normalize(vector_b - vector_a));

/**
 * Calculates the 2D angle between two 2D vectors.
 * @param vector_a The first vector to be examined.
 * @param vector_b The second vector to be examined.
 * @return The 2D angle between vectors in degrees.
 */
function MTH_vectorAngleBetween2D(vector_a,
                                  vector_b) = atan2(vector_b[0] - vector_a[0],
                                                    vector_b[1] - vector_a[1]);

/**
 * @deprecated
 * Mirrors a vector.
 * @param vector The vector to be mirrored.
 * @return A mirrored version of the vector.
 */
function MTH_vectorMirror2D(vector) = [ vector[0], -vector[1] ];

/**
 * Rotates a 2D vector in degrees.
 * @param degrees The amount to rotate the vector in degrees.
 * @param vector The vector to rotate.
 * @return The rotated vector.
 */
function MTH_vectorRotate2D(degrees, vector) = [
    cos(degrees) * vector[0] + sin(degrees) * vector[1],
    cos(degrees) * vector[1] - sin(degrees) * vector[0]
];

/**
 * Computes the area of a circle.
 * @param radius The radius of the circle.
 * @return The square area of the circle.
 */
function MTH_circleArea(radius) = PI * pow(radius, 2);

/**
 * computes the radius of a circle using 3 points on its perimeter.
 * @param point_a A 2D point on the perimeter of the circle.
 * @param point_b A 2D point on the perimeter of the circle.
 * @param point_c A 2D point on the perimeter of the circle.
 * @return The radius of the circle.
 */
function MTH_circleRadiusFromPoints(point_a, point_b, point_c) =
    (MTH_distance2D(point_a, point_b) * MTH_distance2D(point_b, point_c) *
     MTH_distance2D(point_c, point_a)) /
    (4 * MTH_triangleAreaFromPoints(point_a, point_b, point_c));

/**
 * Computes the radius of a circle using 3 lengths along its perimeter.
 * @param length_a A length along the perimeter of the circle.
 * @param length_b A length along the perimeter of the circle.
 * @param length_c A length along the perimeter of the circle.
 * @return the radius of the circle.
 */
function MTH_circleRadiusFromLengths(length_a, length_b, length_c) =
    (point_a * point_b * point_c) /
    (4 * MTH_triangleAreaFromLengths(point_a, point_b, point_c));

/**
 * Computes the area of a triangle using its 3 forming points.
 * @param point_a A 2D point forming the triangle.
 * @param point_b A 2D point forming the triangle.
 * @param point_c A 2D point forming the triangle.
 * @return The area of the triangle.
 */
function MTH_triangleAreaFromPoints(point_a, point_b, point_c) =
    MTH_triangleAreaFromLengths(MTH_distance2D(point_a, point_b),
                                MTH_distance2D(point_b, point_c),
                                MTH_distance2D(point_c, point_a));

/**
 * Computes the area of a triangle using its 3 forming lengths.
 * @param length_a A length forming the triangle.
 * @param length_b A length forming the triangle.
 * @param length_c A length forming the triangle.
 * @return The area of the triangle.
 */
function MTH_triangleAreaFromLengths(length_a, length_b, length_c) =
    sqrt((length_a + length_b + length_c) * (length_a + length_b - length_c) *
         (length_b + length_c - length_a) * (length_c + length_a - length_b)) /
    4;

/**
 * Converts a 2D cartesian vector to Polar space.
 * @param vector The vector to be converted.
 * @return The vector in Polar space.
 */
function MTH_cartesianToPolar2D(vector) =
    [ MTH_distance1D(vector[0], vector[1]), atan2(vector[1], vector[0]) ];

/**
 * Converts a 2D Polar vector to Cartesian space.
 * @param vector The vector to be converted.
 * @return The vector in Cartesian space.
 */
function MTH_polarToCartesian2D(vector) =
    [ vector[0] * cos(vector[1]), vector[0] * sin(vector[1]) ];

/*
 * Rescale an object with respect to a point of reference.
 * @param factor The ratio to scale by.
 * @param reference The point of reference to scale relative to.
 */
module MTH_localScale(factor, reference = [ 0, 0, 0 ])
{
    translate(-reference) scale(factor) translate(reference) children(0);
}

module
testMath()
{
    echo("Currently no tests for MTH module.");
}
