include <cornucopia/util/measures/standard.scad>
NM = 0.000001 * MM;
UM = 0.001 * MM;
CM = 10.0 * MM;
DM = 100.0 * MM;
M = 1000.0 * MM;
DAM = 10000.0 * MM;
HM = 100000.0 * MM;
KM = 1000000.0 * MM;

M2 = 2 * MM;
M3 = 3 * MM;
M4 = 4 * MM;
M5 = 5 * MM;
M6 = 6 * MM;
M8 = 8 * MM;
M10 = 10 * MM;

function MSR_metric(km = 0,
                    hm = 0,
                    dam = 0,
                    m = 0,
                    dm = 0,
                    cm = 0,
                    um = 0,
                    nm = 0,
                    mm = 0) = km * KM + hm * HM + dam * DAM + m * M + dm * DM
                              + cm * CM + um * UM + nm * NM + mm * MM;

module
testMetric()
{
    echo(TST_equal("3 meters to mm", 3 * M, 3000));
    echo(TST_equal("999.9 km to mm", 999.9 * KM, 999900000));
    echo(TST_approximately("1 meter, 35 cm, and 1 nm to mm",
                           MSR_metric(m = 1, cm = 35, nm = 1),
                           1350));
}
