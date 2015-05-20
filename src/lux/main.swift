import luxKit
import ReactiveCocoa
import Result
import ReactiveTask

let iMap = instrumentFileAtPath("/Users/swizzlr/github/public/lux/fixtures/minimalViableTest/pre.swift")

private let o = executeAndParseTestCommand("/Users/swizzlr/github/public/lux/fixtures/minimalViableTest/test")

println(o!.value!)

// Future work
private func reportForInstrumentationMap(map: InstrumentationMap, withExecutedLines executedLines: CountedSet<LineIdentifier>) -> CoverageReport {
    return CoverageReport()
}


