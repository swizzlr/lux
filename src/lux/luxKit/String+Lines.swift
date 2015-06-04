extension String {
    public struct Line: Hashable, Equatable, Printable {
        let lineNumber: Int
        let lineContent: String
        let rangeOfLineInContainingString: NSRange
        let containingString: String

        public static func dummyLineWithLineNumber(lineNumber: Int) -> Line {
            return Line(lineNumber: lineNumber,
                lineContent: "",
                rangeOfLineInContainingString: NSRange(location: 0, length: 0),
                containingString: "")
        }

        public var hashValue: Int {
            get {
                return lineContent.hashValue & lineNumber.hashValue & containingString.hashValue & rangeOfLineInContainingString.location & rangeOfLineInContainingString.length
            }
        }
        public var description: String {
            get {
                return String(lineNumber)
            }
        }
    }
    var lines: [Line] {
        get {
            let st = self as NSString
            var lines: [Line] = []
            var currentLineNumber = 1
            var offset = 0
            st.enumerateLinesUsingBlock { (line, _) -> Void in
                let range = NSRange(location: offset, length: count(line))
                lines.append(Line(lineNumber: currentLineNumber, lineContent: line, rangeOfLineInContainingString: range, containingString: self))
                currentLineNumber = currentLineNumber + 1
                offset = offset + count(line) // length of line
                offset = offset + 1 // line delimiter
            }
            return lines
        }
    }

    // Stolen from Carthage:FrameworkExtensions.swift
    /// Returns a producer that will enumerate each line of the receiver, then
    /// complete.
    public var linesProducer: SignalProducer<String, NoError> {
        return SignalProducer { observer, disposable in
            (self as NSString).enumerateLinesUsingBlock { (line, stop) in
                sendNext(observer, line)

                if disposable.disposed {
                    stop.memory = true
                }
            }

            sendCompleted(observer)
        }
    }
}

public func ==(lhs: String.Line, rhs: String.Line) -> Bool {
    return (lhs.lineContent == rhs.lineContent) && (lhs.containingString == rhs.containingString) && (lhs.lineNumber == rhs.lineNumber) && NSEqualRanges(rhs.rangeOfLineInContainingString, lhs.rangeOfLineInContainingString)
}

import ReactiveCocoa
