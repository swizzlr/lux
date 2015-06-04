/// A globally unique identifier for a line
public struct LineIdentifier {
    public let filename: String
    public let lineNumber: Int
    public init(filename: String, lineNumber: Int) {
        self.filename = filename
        self.lineNumber = lineNumber
    }
}
extension LineIdentifier: Hashable {
    public var hashValue: Int {
        get {
            return filename.hashValue ^ lineNumber.hashValue
        }
    }
}
extension LineIdentifier: Equatable {}
public func ==(lhs: LineIdentifier, rhs: LineIdentifier) -> Bool {
    return (lhs.filename == rhs.filename) && (lhs.lineNumber == rhs.lineNumber)
}
