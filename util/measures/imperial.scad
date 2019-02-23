include <cornucopia/util/measures/standard.scad>

IN = 25.4 * MM;
FT = 304.8 * MM;
YD = 914.4 * MM;
MI = 1609344.0 * MM;
THOU = 0.0254 * MM;
MIL = THOU;

INCH = IN;
FOOT = FT;
FEET = FT;
YARD = YD;
MILE = MI;

module testImperial() {
    echo(TST_approximately("3 yards to mm", 3 * YD, 2743.2));
    echo(TST_approximately("999.9 in to mm", 999.9 * IN, 25397.46));
}
