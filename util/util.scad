/**
 * These functions are adapted from the Missile library.
 * https://github.com/oampo/missile
 */

/**
 * Tests if an object is iterable.
 * @param object The object to be tested.
 * @return True for iterable, false for non-iterable.
 */
function iterable(object) = (len(object) != undef);

/**
 * Tests if a vector is empty.
 * @param vector The vector to be tested.
 * @return True if vector is empty, false otherwise.
 */
function empty(vector) = (len(vector) == 0);

/**
 * Converts a range to a vector.
 * @param range The range to be converted.
 * @return A vector transformed from the range.
 */
function vector(range) = [for (i=range) i];

/**
 * Returns the first element of a vector. 
 * @param vector The vector to be examined.
 * @return The first element of a vector, otherwise undef.
 */
function head(vector) = vector[0];

/**
 * Returns a vector containing all except the first element of a vector.
 * @param vector The vector to be examined.
 * @return A vector containing all but the first element, otherwise undef.
 */
function tail(vector) =
    empty(vector) ? undef :
    len(vector) == 1 ? [] :
    [for (i = [1 : len(vector) - 1]) vector[i]];

/**
 * Returns the last element of a vector.
 * @param vector The vector to be examined.
 * @return The last element, otherwise undef.
 */
function last(vector) =
    empty(vector) ? undef :
    len(vector) == 1 ? vector[0] :
    last(tail(vector));

/**
 * Reverses a vector.
 * @param vector The vector to be reversed.
 * @return A reversed version of the vector.
 */
function reverse(vector) =
    empty(vector) ? [] :
    concat(reverse(tail(vector)), head(vector));

/**
 * Recursively compares vectors to ensure every element is equal. Better than
 * standard ==.
 * @param value_a The first value to compare to.
 * @param value_b The second value to compare to.
 * @return True if equal, false otherwise.
 */
function equal(value_a, value_b) =
    // valueA is iterable, but valueB isn't
    (!iterable(value_a) && iterable(value_b)) ? false :
    // valueB is iterable, but valueA isn't
    (iterable(value_a) && !iterable(value_b)) ? false :
    // Neither are iterable, so compare using ==
    (!iterable(value_a) && !iterable(value_b)) ? (value_a == value_b) :
    // Both iterables
    (empty(value_a) && empty(value_b)) ? true :
    // Both iterables are a different length
    (empty(value_a) || empty(value_b)) ? false :
    // If first values are different return false
    (!equal(head(value_a), head(value_b))) ? false :
    // Else check the remaining elements
    equal(tail(value_a), tail(value_b));

/**
 * Returns true if all elements are true, false otherwise.
 * @param vector The vector to be examined.
 * @return True if all elements are true, false otherwise.
 */
function all(vector) =
    (len(vector) == 0) ? true :
    (!head(vector)) ? false:
    all(tail(vector));

/**
 * Returns true if any one of the elements are true, false otherwise.
 * @param vector The vector to be examined.
 * @return True if any one of the elements are true, false otherwise.
 */
function any(vector) =
    (len(vector) == 0) ? false :
    head(vector) ? true :
    any(tail(vector));

/**
 * Checks if the vector has a specific value within it. This function uses the
 * recursive equality check.
 * @param vector The vector to be searched
 * @param value The value to be searched for.
 * @return True if found, false otherwise.
 */
function contains(vector, value) =
    (len(vector) == 0) ? false :
    equal(head(vector), value) ? true :
    contains(tail(vector), value);

/**
 * Returns a re-ordered matrix (vector of vectors), where the i-th vector
 * contains the i-th element from each of the input vectors.
 * @example zip([[1, 2, 3], [4, 5, 6]]) -> [[1, 4], [2, 5], [3, 6]]
 * @param matrix The vector of vectors to be re-arranged.
 * @return A re-ordered matrix.
 */ 
function zip(matrix) =
    len(matrix) == 0 ? [] :
    (min([for (i=matrix) len(i)]) == 0) ? [] :
    let(
        remainder = [for (i=[0:len(matrix) - 1]) tail(matrix[i])],
        value = [for (i=[0:len(matrix) - 1]) head(matrix[i])]
    )
    concat([value], zip(remainder));

/**
 * Quicksorts the vector in ascending order.
 * @param vector The vector to be sorted.
 * @return The sorted vector.
 */
function sort(vector) =
    empty(vector) ? [] :
    let(
        pivot = vector[floor(len(vector)/2)],
        below = [for (y = vector) if (y  < pivot) y],
        equal = [for (y = vector) if (y == pivot) y],
        above = [for (y = vector) if (y  > pivot) y]
    )
    concat(sort(below), equal, sort(above));

/**
 * Filters a vector of values. A coefficient between 0 and 1 will act as a
 * low-pass filter. A coefficient between -1 and 0 will act as a high-pass
 * filter.
 * @param vector The vector to be filtered.
 * @param coefficient The value which determines the filter.
 * @return A filtered vector of values.
 */
function onePoleFilter(vector, coefficient, previous=undef) =
    empty(vector) ? [] :
    (previous == undef) ? onePoleFilter(vector, coefficient, head(vector)) :
    let(
        next = head(vector) * (1 - coefficient) + previous * coefficient,
        remainder = tail(vector)
    )
    concat(next, onePoleFilter(remainder, coefficient, next));

module testUtil() {
    echo(testTrue("Iterable", iterable([1, 2, 3])));
    echo(testFalse("Not iterable", iterable(1)));

    echo(testTrue("Empty", empty([])));
    echo(testFalse("Not empty", empty([1, 2, 3])));

    echo(testEqual("Head", head([1, 2, 3]), 1));

    echo(testEqual("Tail some", tail([1, 2, 3]), [2, 3]));
    echo(testEqual("Tail one", tail([1]), []));
    echo(testEqual("Tail zero", tail([]), undef));

    echo(testEqual("Last some", last([1, 2, 3]), 3));
    echo(testEqual("Last one", last([1]), 1));
    echo(testEqual("Last zero", last([]), undef));

    echo(testEqual("Reverse some", reverse([1, 2, 3]), [3, 2, 1]));
    echo(testEqual("Reverse zero", reverse([]), []));

    echo(testTrue("Equal number", equal(0, 0), true));
    echo(testFalse("Not equal number", equal(0, 5)));
    echo(testTrue("Equal empty list", equal([], [])));
    echo(testTrue("Equal list", equal([1, 2, 4], [1, 2, 4])));
    echo(testFalse("Not equal list", equal([1, 2, 3], [1, 2, 4])));
    echo(testTrue("Equal nested list", equal([[1, 2, 3], [4, 5, 6]],
                                             [[1, 2, 3], [4, 5, 6]])));
    echo(testFalse("Not equal nested list", equal([[1, 2, 3], [4, 5, 6]],
                                                  [[1, 2, 4], [4, 5, 6]])));
    echo(testFalse("Equal unbalanced list", equal([[1, 2, 3], [4, 5, 6]],
                                                  [7, [4, 5, 6]])));

    echo(testTrue("All", all([true, true, true])));
    echo(testFalse("Not all", all([true, true, false])));

    echo(testTrue("Any", any([false, false, true])));
    echo(testFalse("Not any", any([false, false, false])));

    echo(testTrue("Contains", contains([1, 2, 3], 2)));
    echo(testFalse("Doesn't contain", contains([1, 2, 3], 6)));

    echo(testEqual("Zip zero", zip([]), []));
    echo(testEqual("Zip zero 2", zip([[], [], []]), []));
    echo(testEqual("Zip zero 3", zip([[], [1], [2]]), []));
    echo(testEqual("Zip equal length",
                   zip([[1, 2, 3], [4, 5, 6], [7, 8, 9]]),
                       [[1, 4, 7], [2, 5, 8], [3, 6, 9]]));
    echo(testEqual("Zip different length",
                   zip([[1, 2, 3], [4, 5], [7, 8, 9]]),
                       [[1, 4, 7], [2, 5, 8]]));

    echo(testEqual("Sort zero", sort([]), []));
    echo(testEqual("Sort some", sort([4, 2, 8, 16, 1]), [1, 2, 4, 8, 16]));

    echo(testEqual("One Pole Filter Zero", onePoleFilter([], 0), []));
    echo(testEqual("One Pole Filter Some", onePoleFilter([1, 2, 3], 0), [1, 2, 3]));
    echo(testEqual("One Pole Filter Positive",
                   onePoleFilter([4, 2, 5], 0.5), [4, 3, 4]));
    echo(testEqual("One Pole Filter Negative",
    onePoleFilter([4, 2, 5], -0.5), [4, 1, 7]));
}
