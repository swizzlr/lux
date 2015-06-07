import Quick
import Nimble
import luxKit
import SourceKittenFramework

final class ReportingSpec: QuickSpec {
    override func spec() {
        describe("When reporting") {
            context("given an instrumented file and a counted set of line identifier representing which lines were hit") {
                let instrumentationMap: FileInstrumentationMap = [
                    (String.Line.dummyLineWithLineNumber(1), .NotInstrumented),
                    (String.Line.dummyLineWithLineNumber(2), .NotInstrumented),
                    (String.Line.dummyLineWithLineNumber(3), .Instrumented),
                    (String.Line.dummyLineWithLineNumber(4), .Instrumented),
                    (String.Line.dummyLineWithLineNumber(5), .Instrumented),
                    (String.Line.dummyLineWithLineNumber(6), .NotInstrumented),
                    (String.Line.dummyLineWithLineNumber(7), .Instrumented),
                    (String.Line.dummyLineWithLineNumber(8), .Instrumented),
                    (String.Line.dummyLineWithLineNumber(9), .NotInstrumented),
                    (String.Line.dummyLineWithLineNumber(10), .NotInstrumented)
                ]
                let linesExecuted: CountedSet<LineIdentifier> = [
                    LineIdentifier(filename: "Module.swift", lineNumber: 3),
                    LineIdentifier(filename: "Module.swift", lineNumber: 4),
                    LineIdentifier(filename: "Module.swift", lineNumber: 5),
                    LineIdentifier(filename: "Module.swift", lineNumber: 3),
                    LineIdentifier(filename: "Module.swift", lineNumber: 4),
                    LineIdentifier(filename: "Module.swift", lineNumber: 5),
                    LineIdentifier(filename: "Module.swift", lineNumber: 3),
                    LineIdentifier(filename: "Module.swift", lineNumber: 8)
                ]
                let lineReport: Array<LineReport> = [
                    .NotInstrumented,
                    .NotInstrumented,
                    .Instrumented(hitCount: 3),
                    .Instrumented(hitCount: 2),
                    .Instrumented(hitCount: 2),
                    .NotInstrumented,
                    .Instrumented(hitCount: 0),
                    .Instrumented(hitCount: 1),
                    .NotInstrumented,
                    .NotInstrumented
                ]
                it("it should produce a file report") {
                    let fileReport: FileReport = reportCoverageForFilename("Module.swift")(instrumentationMap: instrumentationMap)(linesExecuted: linesExecuted).value!
                    expect(fileReport.lineReports).to(equal(lineReport))
                    
                }
            }
        }
    }
}