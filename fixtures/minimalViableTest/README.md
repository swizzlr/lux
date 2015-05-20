#Minimum Viable Test Fixture

Without using Xcode or XCTest, this represents the smallest possible kind of unit test. A main file contains the "test suite" built using asserts, and "pre.swift" contains the function under test. The `test` shell script will build, run and delete the executable for you.
