#Fixtures

Put each fixture in a folder. It will have a corresponding `final` test case class that is a subclass of `InstrumentationFunctionalityTest`.

Each fixture must have a pre.swift and post.swift.

Todo: factor out reporting tests into a separate class and fixtures.

It may also have a `test` shell script to run the test, and a `coveralls_output.json` describing expected output.
