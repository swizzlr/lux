import luxKit
import ReactiveCocoa
import Result
import ReactiveTask

let iMap = instrumentFileAtPath("/Users/swizzlr/github/public/lux/fixtures/minimalViableTest/pre.swift")

private let o = executeAndParseTestCommand("/Users/swizzlr/github/public/lux/fixtures/minimalViableTest/test")

println(o!.value!)

let y = reportCoverageForFilename("pre.swift")(instrumentationMap: iMap)(linesExecuted: o!.value!)
println(y)

