include <cornucopia/util/measures/standard.scad>
include <cornucopia/util/util.scad>
/**
 * These functions are adapted from the Test Card library.
 * https://github.com/oampo/testcard
 */

function TST_pass(name) = str(name, " passed");

function TST_fail(name, type, value, expected) =
    str(name, " failed.  Got ", value, ". Expected to ", type, " ", expected);

function TST_equal(name,
                   value,
                   expected) = UTL_equal(value, expected)
                                   ? TST_pass(name)
                                   : TST_fail(name, "equal", value, expected);

function TST_notEqual(name, value, expected) = (!UTL_equal(value, expected))
                                                   ? TST_pass(name)
                                                   : TST_fail(name,
                                                              "not equal",
                                                              value,
                                                              expected);

function TST_true(name, value) = value ? TST_pass(name)
                                       : TST_fail(name, "equal", value, true);

function TST_false(name, value) = (!value)
                                      ? TST_pass(name)
                                      : TST_fail(name, "equal", value, false);

function TST_in(name,
                value,
                expected) = (UTL_contains(expected, value))
                                ? TST_pass(name)
                                : TST_fail(name, "be in", value, expected);

function TST_notIn(name, value, expected) = (!UTL_contains(expected, value))
                                                ? TST_pass(name)
                                                : TST_fail(name,
                                                           "not be in",
                                                           value,
                                                           expected);

function TST_approximately(name, value, fuzzy_expected) =
    fuzzy_expected < value + EPSILON
        ? fuzzy_expected > value - EPSILON
              ? TST_pass(name)
              : TST_fail(name, "approximately equal", value, fuzzy_expected)
        : TST_fail(name, "approximately equal", value, fuzzy_expected);

module
testUnitTest()
{
    echo(TST_equal("Equality", [ 1, 2, 4, 8 ], [ 1, 2, 4, 8 ]));
    echo(TST_notEqual("Non-equality", [ 1, 2, 4, 8 ], [ 0, 1, 1, 2 ]));
    echo(TST_true("Truthiness", 1 + 1 == 2));
    echo(TST_false("Falseness", 1 + 1 == 3));
    echo(TST_in("Presence", 4, [ 1, 2, 4, 8 ]));
    echo(TST_notIn("Absence", 16, [ 1, 2, 4, 8 ]));
    echo(TST_approximately("Approximately Equal", 15 + (EPSILON / 2), 15));
}
