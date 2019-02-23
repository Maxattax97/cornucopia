/**
 * These functions are adapted from the Missile library.
 * https://github.com/oampo/missile
 */

/**
 * Tests if an object is iterable.
 * @param object The object to be tested.
 * @return True for iterable, false for non-iterable.
 */
function UTL_iterable(object) = (len(object) != undef);

/**
 * Tests if a vector is empty.
 * @param vector The vector to be tested.
 * @return True if vector is empty, false otherwise.
 */
function UTL_empty(vector) = (len(vector) == 0);

/**
 * Converts a range to a vector.
 * @param range The range to be converted.
 * @return A vector transformed from the range.
 */
function UTL_vector(range) = [for (i=range) i];

/**
 * Returns the first element of a vector. 
 * @param vector The vector to be examined.
 * @return The first element of a vector, otherwise undef.
 */
function UTL_head(vector) = vector[0];

/**
 * Returns a vector containing all except the first element of a vector.
 * @param vector The vector to be examined.
 * @return A vector containing all but the first element, otherwise undef.
 */
function UTL_tail(vector) =
    UTL_empty(vector) ? undef :
    len(vector) == 1 ? [] :
    [for (i = [1 : len(vector) - 1]) vector[i]];

/**
 * Returns the last element of a vector.
 * @param vector The vector to be examined.
 * @return The last element, otherwise undef.
 */
function UTL_last(vector) =
    UTL_empty(vector) ? undef :
    len(vector) == 1 ? vector[0] :
    UTL_last(UTL_tail(vector));

/**
 * Reverses a vector.
 * @param vector The vector to be reversed.
 * @return A reversed version of the vector.
 */
function UTL_reverse(vector) =
    UTL_empty(vector) ? [] :
    concat(UTL_reverse(UTL_tail(vector)), UTL_head(vector));

/**
 * Recursively compares vectors to ensure every element is equal. Better than
 * standard ==.
 * @param value_a The first value to compare to.
 * @param value_b The second value to compare to.
 * @return True if equal, false otherwise.
 */
function UTL_equal(value_a, value_b) =
    // valueA is iterable, but valueB isn't
    (!UTL_iterable(value_a) && UTL_iterable(value_b)) ? false :
    // valueB is iterable, but valueA isn't
    (UTL_iterable(value_a) && !UTL_iterable(value_b)) ? false :
    // Neither are iterable, so compare using ==
    (!UTL_iterable(value_a) && !UTL_iterable(value_b)) ? (value_a == value_b) :
    // Both iterables
    (UTL_empty(value_a) && UTL_empty(value_b)) ? true :
    // Both iterables are a different length
    (UTL_empty(value_a) || UTL_empty(value_b)) ? false :
    // If first values are different return false
    (!UTL_equal(UTL_head(value_a), UTL_head(value_b))) ? false :
    // Else check the remaining elements
    UTL_equal(UTL_tail(value_a), UTL_tail(value_b));

/**
 * Returns true if all elements are true, false otherwise.
 * @param vector The vector to be examined.
 * @return True if all elements are true, false otherwise.
 */
function UTL_all(vector) =
    (len(vector) == 0) ? true :
    (!UTL_head(vector)) ? false:
    UTL_all(UTL_tail(vector));

/**
 * Returns true if any one of the elements are true, false otherwise.
 * @param vector The vector to be examined.
 * @return True if any one of the elements are true, false otherwise.
 */
function UTL_any(vector) =
    (len(vector) == 0) ? false :
    UTL_head(vector) ? true :
    UTL_any(UTL_tail(vector));

/**
 * Checks if the vector has a specific value within it. This function uses the
 * recursive equality check.
 * @param vector The vector to be searched
 * @param value The value to be searched for.
 * @return True if found, false otherwise.
 */
function UTL_contains(vector, value) =
    (len(vector) == 0) ? false :
    UTL_equal(UTL_head(vector), value) ? true :
    UTL_contains(UTL_tail(vector), value);

/**
 * Returns a re-ordered matrix (vector of vectors), where the i-th vector
 * contains the i-th element from each of the input vectors.
 * @example zip([[1, 2, 3], [4, 5, 6]]) -> [[1, 4], [2, 5], [3, 6]]
 * @param matrix The vector of vectors to be re-arranged.
 * @return A re-ordered matrix.
 */ 
function UTL_zip(matrix) =
    len(matrix) == 0 ? [] :
    (min([for (i=matrix) len(i)]) == 0) ? [] :
    let(
        remainder = [for (i=[0:len(matrix) - 1]) UTL_tail(matrix[i])],
        value = [for (i=[0:len(matrix) - 1]) UTL_head(matrix[i])]
    )
    concat([value], UTL_zip(remainder));

/**
 * Quicksorts the vector in ascending order.
 * @param vector The vector to be sorted.
 * @return The sorted vector.
 */
function UTL_sort(vector) =
    UTL_empty(vector) ? [] :
    let(
        pivot = vector[floor(len(vector)/2)],
        below = [for (y = vector) if (y  < pivot) y],
        equal = [for (y = vector) if (y == pivot) y],
        above = [for (y = vector) if (y  > pivot) y]
    )
    concat(UTL_sort(below), equal, UTL_sort(above));

/**
 * Filters a vector of values. A coefficient between 0 and 1 will act as a
 * low-pass filter. A coefficient between -1 and 0 will act as a high-pass
 * filter.
 * @param vector The vector to be filtered.
 * @param coefficient The value which determines the filter.
 * @return A filtered vector of values.
 */
function UTL_onePoleFilter(vector, coefficient, previous=undef) =
    UTL_empty(vector) ? [] :
    (previous == undef) ? UTL_onePoleFilter(vector, coefficient, UTL_head(vector)) :
    let(
        next = UTL_head(vector) * (1 - coefficient) + previous * coefficient,
        remainder = UTL_tail(vector)
    )
    concat(next, UTL_onePoleFilter(remainder, coefficient, next));

module testUtil() {
    echo(TST_true("Iterable", UTL_iterable([1, 2, 3])));
    echo(TST_false("Not iterable", UTL_iterable(1)));

    echo(TST_true("Empty", UTL_empty([])));
    echo(TST_false("Not empty", UTL_empty([1, 2, 3])));

    echo(TST_equal("Head", UTL_head([1, 2, 3]), 1));

    echo(TST_equal("Tail some", UTL_tail([1, 2, 3]), [2, 3]));
    echo(TST_equal("Tail one", UTL_tail([1]), []));
    echo(TST_equal("Tail zero", UTL_tail([]), undef));

    echo(TST_equal("Last some", UTL_last([1, 2, 3]), 3));
    echo(TST_equal("Last one", UTL_last([1]), 1));
    echo(TST_equal("Last zero", UTL_last([]), undef));

    echo(TST_equal("Reverse some", UTL_reverse([1, 2, 3]), [3, 2, 1]));
    echo(TST_equal("Reverse zero", UTL_reverse([]), []));

    echo(TST_true("Equal number", UTL_equal(0, 0), true));
    echo(TST_false("Not equal number", UTL_equal(0, 5)));
    echo(TST_true("Equal empty list", UTL_equal([], [])));
    echo(TST_true("Equal list", UTL_equal([1, 2, 4], [1, 2, 4])));
    echo(TST_false("Not equal list", UTL_equal([1, 2, 3], [1, 2, 4])));
    echo(TST_true("Equal nested list", UTL_equal([[1, 2, 3], [4, 5, 6]],
                                             [[1, 2, 3], [4, 5, 6]])));
    echo(TST_false("Not equal nested list", UTL_equal([[1, 2, 3], [4, 5, 6]],
                                                  [[1, 2, 4], [4, 5, 6]])));
    echo(TST_false("Equal unbalanced list", UTL_equal([[1, 2, 3], [4, 5, 6]],
                                                  [7, [4, 5, 6]])));

    echo(TST_true("All", UTL_all([true, true, true])));
    echo(TST_false("Not all", UTL_all([true, true, false])));

    echo(TST_true("Any", UTL_any([false, false, true])));
    echo(TST_false("Not any", UTL_any([false, false, false])));

    echo(TST_true("Contains", UTL_contains([1, 2, 3], 2)));
    echo(TST_false("Doesn't contain", UTL_contains([1, 2, 3], 6)));

    echo(TST_equal("Zip zero", UTL_zip([]), []));
    echo(TST_equal("Zip zero 2", UTL_zip([[], [], []]), []));
    echo(TST_equal("Zip zero 3", UTL_zip([[], [1], [2]]), []));
    echo(TST_equal("Zip equal length",
                   UTL_zip([[1, 2, 3], [4, 5, 6], [7, 8, 9]]),
                       [[1, 4, 7], [2, 5, 8], [3, 6, 9]]));
    echo(TST_equal("Zip different length",
                   UTL_zip([[1, 2, 3], [4, 5], [7, 8, 9]]),
                       [[1, 4, 7], [2, 5, 8]]));

    echo(TST_equal("Sort zero", UTL_sort([]), []));
    echo(TST_equal("Sort some", UTL_sort([4, 2, 8, 16, 1]), [1, 2, 4, 8, 16]));

    echo(TST_equal("One Pole Filter Zero", UTL_onePoleFilter([], 0), []));
    echo(TST_equal("One Pole Filter Some", UTL_onePoleFilter([1, 2, 3], 0), [1, 2, 3]));
    echo(TST_equal("One Pole Filter Positive",
                   UTL_onePoleFilter([4, 2, 5], 0.5), [4, 3, 4]));
    echo(TST_equal("One Pole Filter Negative",
        UTL_onePoleFilter([4, 2, 5], -0.5), [4, 1, 7]));
}
