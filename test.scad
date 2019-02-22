include <cornucopia/all_recurse.scad>
import("/home/max/Downloads/phillips_screw.stl", convexity=3);

$fn = 100;

//cube([mm, mm, mm], center = true);
//
//translate([mm + cm, 0, 0]) {
//    cube([cm, cm, cm], center = true);
//    translate([cm + in, 0, 0]) {
//        cube([in, in, in], center = true);
//    }
//}