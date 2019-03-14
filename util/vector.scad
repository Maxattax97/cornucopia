include <conrnucopia/util/math.scad>

/**
 * These functions are adapted from the Obijuan's ObiSCAD library.
 * https://github.com/Obijuan/obiscad
 */

/**
 * Calculate the module of a vector.
 *
 * @param vector The vector to calculate the module of.
 * @return The module of the vector.
 */
function VEC_module(vector) = (sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]));

/**
 * Calculate the cross product of two vectors.
 *
 * @param vector_a The first vector to compute the cross product of.
 * @param vector_b The second vector to compute the cross product of.
 * @return The cross product of vector_a and vector_b
 */
function VEC_cross(vector_a, vector_b) = [
    vector_a[1] * vector_b[2] - vector_b[1] * vector_a[2],
    -(vector_a[0] * vector_b[2] - vector_b[0] * vector_a[2]),
    vector_a[0] * vector_b[1] - vector_b[0] * vector_a[1]
];

/**
 * Calculate the dot product of two vectors
 *
 * @param vector_a The first vector to compute the dot product of.
 * @param vector_b The second vector to compute the dot product of.
 * @return The dot product of vector_a and vector_b.
 */
function VEC_dot(vector_a, vector_b) = vector_a[0] * vector_b[0] + vector_a[1] * vector_b[1] + vector_a[2] * vector_b[2];

/**
 * Return the unit vector of a vector.
 *
 * @param vector The vector to compute the unit vector of.
 * @return The unit vector of vector.
 */
function VEC_unit(vector) = vector / mod(vector);

/**
 * Calculates the angle between two vectors.
 *
 * @param vector_a The first vector to be examined.
 * @param vector_b The second vector to be examined.
 * @return The 3D angle between vectors in degrees.
 */
function VEC_vectorAngleBetween(vector_a,
                                vector_b) = MTH_vectorAngleBetween(vector_a,
                                                                   vector_b);

//-- Return an arbitrary unitary vector othogonal to v
function VEC_orthogonalUnit(v) =
    (v.x == 0 && v.y == 0 && v.z == 0)
        ? undef
        : (v.x == 0 && v.y == 0)
              ? [ 1, 0, 0 ]
              : let(r = norm([ v.x, v.y, 0 ]))[v.y / r, -v.x / r, 0];

//-- Return an arbitrary vector othogonal to v
function vectorEC_orthogonal(vector) =
    (vector.x == 0 && vector.y == 0 && vector.z == 0)
        ? undef
        : (vector.x == 0 && vector.y == 0)
              ? [ 1, 0, 0 ]
              : (vector.y == 0) ? [ 1, 0, 0 ] : [ 1, -vector.x / vector.y, 0 ];

//----------------------------------------------------------
//--  Draw a point in the position given by the vector p
//----------------------------------------------------------
module VEC_point(p)
{
    translate(p) sphere(r = 0.7, $fn = RESOLUTION_DRAFT);
}

//------------------------------------------------------------------
//-- Draw a vector poiting to the z axis
//-- This is an auxiliary module for implementing the vector module
//--
//-- Parameters:
//--  l: total vector length (line + arrow)
//--  l_arrow: Vector arrow length
//--  mark: If true, a mark is draw in the vector head, for having
//--    a visual reference of the rolling angle
//------------------------------------------------------------------
module VEC_vectorZ(l = 10, l_arrow = 4, mark = false)
{
    //-- vector body length (not including the arrow)
    lb = l - l_arrow;

    //-- The vector is locatead at 0,0,0
    translate([ 0, 0, lb / 2 ]) union()
    {

        //-- Draw the arrow
        translate([ 0, 0, lb / 2 ]) cylinder(r1 = 2 / 2,
                                             r2 = 0.2,
                                             h = l_arrow,
                                             $fn = obiscad_drawing_resolution);

        //-- Draw the mark
        if (mark) {
            translate([ 0, 0, lb / 2 + l_arrow / 2 ]) translate([ 1, 0, 0 ])
                cube([ 2, 0.3, l_arrow * 0.8 ], center = true);
        }

        //-- Draw the body
        cylinder(
            r = 1 / 2, h = lb, center = true, $fn = obiscad_drawing_resolution);
    }

    //-- Draw a sphere in the vector base
    sphere(r = 1 / 2, $fn = obiscad_drawing_resolution);
}

//-----------------------------------------------------------------
//-- ORIENTATE OPERATOR
//--
//--  Orientate an object to the direction given by the vector v
//--  Parameters:
//--    v : Target orientation
//--    vref: Vector reference. It is the vector of the local frame
//--          of the object that want to be poiting in the direction
//--          of v
//--    roll: Rotation of the object around the v axis
//-------------------------------------------------------------------
module VEC_orient(v, vref = [ 0, 0, 1 ], roll = 0)
{
    //-- Calculate the rotation axis
    cref = cross(vref, v);
    raxis = mod(cref) == 0 ? [ 1, 0, 0 ] : cref;

    //-- Calculate the angle between the vectors
    ang = anglev(vref, v);

    //-- Rotate the child!
    rotate(a = roll, v = v) rotate(a = ang, v = raxis) child(0);
}

//---------------------------------------------------------------------------
//-- Draw a vector
//--
//-- There are two modes of drawing the vector
//-- * Mode 1: Given by a cartesian point(x,y,z). A vector from the origin
//--           to the end (x,y,z) is drawn. The l parameter (length) must
//--           be 0  (l=0)
//-- * Mode 2: Give by direction and length
//--           A vector of length l pointing to the direction given by
//--           v is drawn
//---------------------------------------------------------------------------
//-- Parameters:
//--  v: Vector cartesian coordinates
//--  l: total vector length (line + arrow)
//--  l_arrow: Vector arrow length
//    mark: If true, a mark is draw in the vector head, for having
//--    a visual reference of the rolling angle
//---------------------------------------------------------------------------
module VEC_vector(v, l = 0, l_arrow = 4, mark = false)
{
    //-- Get the vector length from the coordinates
    mod = mod(v);

    //-- The vector is very easy implemented by means of the orientate
    //-- operator:
    //--  orientate(v) vectorz(l=mod, l_arrow=l_arrow)
    //--  BUT... in OPENSCAD 2012.02.22 the recursion does not
    //--    not work, so that if the user use the orientate operator
    //--    on a vector, openscad will ignore it..
    //-- The solution at the moment (I hope the openscad developers
    //--  implement the recursion in the near future...)
    //--  is to repite the orientate operation in this module

    //---- SAME CALCULATIONS THAN THE ORIENTATE OPERATOR!
    //-- Calculate the rotation axis

    vref = [ 0, 0, 1 ];
    cref = cross(vref, v);
    raxis = mod(cref) == 0 ? [ 1, 0, 0 ] : cref;

    //-- Calculate the angle between the vectors
    ang = anglev(vref, v);

    //-- orientate the vector
    //-- Draw the vector. The vector length is given either
    //--- by the mod variable (when l=0) or by l (when l!=0)
    if (l == 0)
        rotate(a = ang, v = raxis)
            vectorz(l = mod, l_arrow = l_arrow, mark = mark);
    else
        rotate(a = ang, v = raxis)
            vectorz(l = l, l_arrow = l_arrow, mark = mark);
}

//----------------------------------------------------
//-- Draw a Frame of reference
//-- Parameters:
//-- l: length of the Unit vectors
//-----------------------------------------------------
module VEC_frame(l = 10, l_arrow = 4)
{

    //-- Z unit vector
    color("Blue") vector([ 0, 0, l ], l_arrow = l_arrow);

    //-- X unit vector
    color("Red") vector([ l, 0, 0 ], l_arrow = l_arrow);

    //-- Y unit vector
    color("Green") vector([ 0, l, 0 ], l_arrow = l_arrow);

    //-- Origin
    color("Gray") sphere(r = 1, $fn = obiscad_drawing_resolution);
}

//--------------------------------------------------
//-- Modules for testings and examples
//-- Testing that the vector library is working ok
//--------------------------------------------------

//-- 22 vectors in total are drawn, poiting to different directions
module
testVector()
{
    module Test_vectors1()
    {

        a = 20;
        k = 1;

        //--  Add a frame of reference (in the origin)
        frame(l = a);

        //-- Negative vectors, pointing towards the three axis: -x, -y, -z
        color("Red") vector([ -a, 0, 0 ]);
        color("Green") vector([ 0, -a, 0 ]);
        color("Blue") vector([ 0, 0, -a ]);

        //-- It is *not* has been implemented using a for loop on purpose
        //-- This way, individual vectors can be commented out or highlighted

        //-- vectors with positive z
        vector([ a, a, a * k ]);
        vector([ 0, a, a * k ]);
        vector([ -a, a, a * k ]);
        vector([ -a, 0, a * k ]);

        vector([ -a, -a, a * k ]);
        vector([ 0, -a, a * k ]);
        vector([ a, -a, a * k ]);
        vector([ a, 0, a * k ]);

        //-- Vectors with negative z
        vector([ a, a, -a * k ]);
        vector([ 0, a, -a * k ]);
        vector([ -a, a, -a * k ]);
        vector([ -a, 0, -a * k ]);

        vector([ -a, -a, -a * k ]);
        vector([ 0, -a, -a * k ]);
        vector([ a, -a, -a * k ]);
        vector([ a, 0, -a * k ]);
    }

    //--- Another test...
    module Test_vectors2()
    {

        //-- Add the vector into the vector table
        //-- This vectors are taken as directions
        //-- All the vectors will be drawn wit,h the same length (l)
        vector_table = [
            [ 1, 1, 1 ],
            [ 0, 1, 1 ],
            [ -1, 1, 1 ],
            [ -1, 0, 1 ],
            [ -1, -1, 1 ],
            [ 0, -1, 1 ],
            [ 1, -1, 1 ],
            [ 1, 0, 1 ],
            [ 0, 0, -1 ], // degenerate case
            [ 1, 1, -1 ],
            [ 0, 1, -1 ],
            [ -1, 1, -1 ],
            [ -1, 0, -1 ],
            [ -1, -1, -1 ],
            [ 0, -1, -1 ],
            [ 1, -1, -1 ],
            [ 1, 0, -1 ],
        ];

        //-- Vector length
        l = 20;

        frame(l = 10);

        //-- Draw all the vector given in the table
        //-- The vectors point to the direction given in the table
        //-- They all are drawn with a length equal to l
        for (v = vector_table) {
            //-- Vector given by direction and length
            vector(v, l = l);
        }
    }

    //-- Test the cross product and the angle
    //-- between vectors
    module Test_vector3()
    {
        //-- Start with 2 unit vectors
        v = unitv([ 1, 1, 1 ]);
        u = unitv([ 0, 1, 0 ]);

        //-- Draw the vector in different colors
        //-- Increase the length for drawing
        color("Red") vector(v * 20);
        color("blue") vector(u * 20);

        //-- Get the cross product
        w = cross(v, u);
        vector(w * 20);

        //-- The cross product is NOT conmutative...
        //-- change the order of v and u
        w2 = cross(u, v);
        vector(w2 * 20);

        //-- w should be perpendicular to v and u
        //-- Calculate the angles between them:
        echo("U , V: ", anglev(u, v));
        echo("W , U: ", anglev(w, u));
        echo("W , V: ", anglev(w, v));
    }

    //-- Test the orientate operator
    module Test_vector4()
    {
        o = [ 10, 10, 10 ];
        v = [ -10, 10, 10 ];

        color("Red") vector(o);
        color("Blue") vector(v);

        //-- Orientate the vector o in the direction of v
        orientate(v, o) vector(o);

        //-- Inverse operation: orientate the v vector in the direction
        //-- of o
        orientate(o, v) vector(v);

        //-- Example of orientation of a cube
        orientate(o, vref = [ 10, -2, 5 ], roll = 0)
            cube([ 10, 2, 5 ], center = true);

        vector([ 10, -2, 5 ]);
    }

    //-- Test the degenerate case ie. the vectors are (anti)collinear
    module Test_vector5()
    {
        o = [ 0, 0, 10 ];
        v = [ 0, 0, -10 ];

        color("Red") vector(o);
        color("Blue") vector(v);

        //-- Orientate the vector o in the direction of v
        orientate(v, o) vector(o);

        //-- Inverse operation: orientate the v vector in the direction
        //-- of o
        orientate(o, v) vector(v);
    }

    //-------- Perform tests......

    translate([ 100, 0, 0 ])
    {
        Test_vector1();
        translate([ 0, 100, 0 ])
        {
            Test_vector2();
            translate([ 0, 0, 100 ])
            {
                Test_vector3();
                translate([ 100, 0, 0 ])
                {
                    Test_vector4();
                    translate([ 0, 100, 0 ]) { Test_vector5(); }
                }
            }
        }
    }
}
