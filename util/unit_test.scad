/**
 * These functions are adapted from the Test Card library.
 * https://github.com/oampo/testcard
 */ 

include <cornucopia/util/util.scad>
include <cornucopia/util/measures/standard.scad>

function pass(name) = str(name, " passed");

function fail(name, type, value, expected) =
    str(name, " failed.  Got ", value,
        ". Expected to ", type, " ", expected);

function testEqual(name, value, expected) =
    equal(value, expected) ?
    pass(name) :
    fail(name, "equal", value, expected);

function testNotEqual(name, value, expected) =
    (!equal(value, expected)) ?
    pass(name) :
    fail(name, "not equal", value, expected);

function testTrue(name, value) =
    value ?
    pass(name) :
    fail(name, "equal", value, true);

function testFalse(name, value) =
    (!value) ?
    pass(name) :
    fail(name, "equal", value, false);

function testIn(name, value, expected) =
    (contains(expected, value)) ?
    pass(name) :
    fail(name, "be in", value, expected);

function testNotIn(name, value, expected) =
    (!contains(expected, value)) ?
    pass(name) :
    fail(name, "not be in", value, expected);

function testApproximately(name, value, fuzzy_expected) =
    fuzzy_expected < value + epsilon ?
    fuzzy_expected > value - epsilon ? 
    pass(name) :
    fail(name, "approximately equal", value, fuzzy_expected) :
    fail(name, "approximately equal", value, fuzzy_expected);
    

module testUnitTest() {
    echo(testEqual("Equality", [1, 2, 4, 8], [1, 2, 4, 8]));
    echo(testNotEqual("Non-equality", [1, 2, 4, 8], [0, 1, 1, 2]));
    echo(testTrue("Truthiness", 1 + 1 == 2));
    echo(testFalse("Falseness", 1 + 1 == 3));
    echo(testIn("Presence", 4, [1, 2, 4, 8]));
    echo(testNotIn("Absence", 16, [1, 2, 4, 8]));
    echo(testApproximately("Approximately Equal", 15 + (epsilon / 2), 15));
}
