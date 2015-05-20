// The final coverage report which you can serialize as you like
public struct CoverageReport {
    public let files: Set<FileReport> = Set()
    public init() { }
}

public struct FileReport {
    let file: File
    let originalContents: String
    let lineReports: Array<LineReport>
}

public enum LineReport {
    /// The line was not instrumented
    case NotInstrumented
    /// The line was instrumented.
    /// `hitCount`: The number of times the line was executed in the test suite.
    case Instrumented(hitCount: Int)
}

/// Create a coverage report from an InstrumentationMap and a list of lines executed
public func report(#imap: InstrumentationMap)(linesExecuted: CountedSet<LineIdentifier>) -> Result<CoverageReport, LuxError> {
    return Result.success(CoverageReport())
}


// MARK: {Hash|Equat}able implementations

extension FileReport: Equatable {}
public func ==(lhs: FileReport, rhs: FileReport) -> Bool {
    return (lhs.file == rhs.file)
        && (lhs.originalContents == rhs.originalContents)
        && (lhs.lineReports == rhs.lineReports)
}

extension FileReport: Hashable {
    public var hashValue: Int {
        get {
            return file.hashValue ^ originalContents.hashValue ^ hash(lineReports)
        }
    }
}

extension LineReport: Equatable {}
public func ==(lhs: LineReport, rhs: LineReport) -> Bool {
    switch (lhs, rhs) {
    case (.NotInstrumented, .NotInstrumented):
        return true
    case (.Instrumented(let l), .Instrumented(let r)) where l == r:
        return true
    default:
        return false
    }
}

extension LineReport: Hashable {
    public var hashValue: Int {
        get {
            switch self {
            case .NotInstrumented:
                return Int(INT_MAX)
            case .Instrumented(let c):
                return c
            }
        }
    }
}

import Result
import SourceKittenFramework
