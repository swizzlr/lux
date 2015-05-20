# Instrument program flow
1. Given swift file
1. Filter to lines that contain statements
1. Precede first statement of lines with `println("co.swizzlr.worstthing: __FILE__ // __LINE__");`
1. Record all occurrences of println insertion

# Generate coverage output
1. Build special version of module under test with above modifications
1. Run test suite against module
1. Record output
1. Filter by `co.swizzlr.worstthing`
1. Parse line occurrences
1. For each line generate `null` if no println statement, or an `int` displaying how many times the statement was triggered.

# Submit to coveralls
1. Take above output, profit.
