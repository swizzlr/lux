Since TWTIHD effectively modifies a bunch of files, runs a command and parses the output, all we need are two things:

1. `files`: a relative path specifying which directory or file to modify. Supports globbing.
2. `command`: a shell command that will execute your test suite and print the target-under-test's output
