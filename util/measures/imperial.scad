include <cornucopia/util/measures/standard.scad>

in = 25.4 * mm;
ft = 304.8 * mm;
yd = 914.4 * mm;
mi = 1609344.0 * mm;
thou = 0.0254 * mm;
mil = thou;

inch = in;
foot = ft;
feet = ft;
yard = yd;
mile = mi;

module testImperial() {
    echo(testApproximately("3 yards to mm", 3 * yd, 2743.2));
    echo(testApproximately("999.9 in to mm", 999.9 * in, 25397.46));
}
