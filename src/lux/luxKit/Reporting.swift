// The final coverage report which you can serialize as you like
public struct CoverageReport {
    public let files: Set<FileReport> = Set()
    public init() { }
}

public struct FileReport {
    let filename: String
    var file: File = File(contents: "")
    let originalContents: String = ""
    public let lineReports: Array<LineReport>
    public init(filename: String, lineReports: Array<LineReport>) {
        self.filename = filename
        self.lineReports = lineReports
    }
}

public enum LineReport {
    /// The line was not instrumented
    case NotInstrumented
    /// The line was instrumented.
    /// `hitCount`: The number of times the line was executed in the test suite.
    case Instrumented(hitCount: Int)
}

/// Create a coverage report from an InstrumentationMap and a list of lines executed
public func reportCoverageForFilename(filename: String)(instrumentationMap: FileInstrumentationMap)(linesExecuted: CountedSet<LineIdentifier>)
    -> Result<FileReport, LuxError> {
    return Result(value: FileReport(filename: filename, lineReports: generateLineReportsForFileInstrumentationMap(instrumentationMap, filename, linesExecuted)))
}

private func generateLineReportsForFileInstrumentationMap(imap: FileInstrumentationMap, fileName: String, linesExecuted: CountedSet<LineIdentifier>) -> Array<LineReport> {
    return imap.map { (line, state) in
        switch state {
        case .NotInstrumented:
            return LineReport.NotInstrumented
        case .Instrumented:
            let lineIdentifier = LineIdentifier(filename: fileName, lineNumber: line.lineNumber)
            return linesExecuted[lineIdentifier].map { LineReport.Instrumented(hitCount: $0.count) } ?? LineReport.Instrumented(hitCount: 0)

        }
    }
}

private func getOriginalContentsOfFileAtPath(path: String) -> Result<String, LuxError> {
    let originalFilePath = path + ".orig"
    return Result(File(path: originalFilePath)?.contents, failWith: LuxError.OriginalFileNotFound(currentFile: path))
}


// MARK: {Hash|Equat|Print}able implementations

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

extension LineReport: Printable {
    public var description: String {
        switch self {
        case .NotInstrumented:
            return "Not Instrumented"
        case .Instrumented(let hitCount):
            return "Hit \(hitCount) times"
        }
    }
}

import Result
import SourceKittenFramework
