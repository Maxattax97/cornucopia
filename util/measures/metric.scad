include <cornucopia/util/measures/standard.scad>

nm =    0.000001 * mm;
um =    0.001 * mm;
cm =    10.0 * mm;
dm =    100.0 * mm;
m =     1000.0 * mm;
dam =   10000.0 * mm;
hm =    100000.0 * mm;
km =    1000000.0 * mm;

M2 = 2 * mm;
M3 = 3 * mm;
M4 = 4 * mm;
M5 = 5 * mm;
M6 = 6 * mm;
M8 = 8 * mm;
M10 = 10 * mm;

module testMetric() {
    echo(testEqual("3 meters to mm", 3 * m, 3000));
    echo(testEqual("999.9 km to mm", 999.9 * km, 999900000));
}
