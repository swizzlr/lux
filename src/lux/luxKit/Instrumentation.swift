// This file is an awful huge mess and I am really sorry

public let MagicDelimiter = ":co.swizzlr.lux:"
private let TheMagicInstrumentationCode = "println(\"\(MagicDelimiter)\"+__FILE__+\"\(MagicDelimiter)\"+String(__LINE__));"

// Where the magic happens
// Inserts the magic instrumentation code at specified index
// Returns the supplied string, modified as asked
private func insertInstrumentationCodeAtIndex(index: Int)(inString string: String) -> String {
    let mutString = NSMutableString(string: string)
    mutString.insertString(TheMagicInstrumentationCode, atIndex: index)
    return String(mutString)
}

// Side-effect laden function. Will crash if file doesn't exist.
// Returns instrumentation map for the given file
public func instrumentFileAtPath(path: String) -> FileInstrumentationMap {
    let file = File(path: path)! // If you crashed here, you gave a bad path.
    let (newContents, instrumentationMap) = instrumentString(file.contents)

    // TADA
    // Todo: Use encoding identical to original file https://github.com/swizzlr/lux/issues/23
    var error: NSError?
    newContents.writeToFile(file.path!, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
    assert(error == nil, "Error writing to file, error follows:\n\n\(error!)") // Todo: Handle possible errors correctly https://github.com/swizzlr/lux/issues/24
    return instrumentationMap
}

public enum ReducedInstrumentationState {
    case Instrumented
    case NotInstrumented
    public static func fromInstrumentableState(state: InstrumentableLine.InstrumentableState) -> ReducedInstrumentationState {
        switch state {
        case .Instrumentable, .Instrumented:
            return .Instrumented
        case .NotInstrumentable:
            return .NotInstrumented
        }
    }
}

public struct InstrumentableLine {
    public enum InstrumentableState: Printable {
        case Instrumentable(indexToInsertInstrumentationCode: Int)
        case NotInstrumentable
        case Instrumented(instrumentedLine: String.Line)
        public var description: String {
            get {
                switch self {
                case .Instrumented:
                    return "Instrumented"
                case .NotInstrumentable, .Instrumentable:
                    return "Not Instrumented"
                }
            }
        }
        public static func fromDescription(description: String) -> InstrumentableState {
            switch description {
            case "Instrumented":
                return .Instrumented(instrumentedLine: String.Line(lineNumber: 0, lineContent: "", rangeOfLineInContainingString: NSRange(location: 0, length: 0), containingString: ""))
            case "Not Instrumented":
                return .NotInstrumentable
            default:
                assertionFailure("Invalid description \(description) for InstrumentableState")
                return .NotInstrumentable
            }
        }
    }
    let line: String.Line
    let state: InstrumentableState
}

public typealias FileInstrumentationMap = Array<(String.Line, ReducedInstrumentationState)>
/// Line Number : InstrumentableState with empty associated values
public typealias ReducedInstrumentationMap = Dictionary<Int, InstrumentableLine.InstrumentableState>

public func instrumentString(string: String) -> (String, FileInstrumentationMap) {
    let file = File(contents: string)
    let structure = Structure.decode(JSON.parse(Request.EditorOpen(file).send())).value! // TODO: isn't there some nicer way of writing this?

    // Step 1: find the functions. Heavily stolen from FunctionBodyLengthRule.swift, of SwiftLint, with a peppering of my own modelling
    let functions = reduceFunctions(structure)
    let contents = file.contents
    let rangeOfFunctionBodyInFile = NSString.byteRangeToNSRange(file.contents)

    let linesInFile = contents.lines
    let rangesToInstrument = functions.map {
        return rangeOfFunctionBodyInFile(start: $0.bodyOffset!, length: $0.bodyLength!)! // array of ranges denoting function body
    }

    // Step 2: given the lines and array of ranges, we want to filter the lines that have ranges that intersect with the ranges that we want to instrument

    // The following two functions are essentially duplicated because the first function, for some reason, segfaults the compiler. Would like to make the second function use the first one.
    func findOverlappingRangeInArrayOfRanges(array: Array<NSRange>)(range: NSRange) -> NSRange? {
        for r in array {
            // "If the returned range’s length field is 0, then the two ranges don’t intersect"
            if NSIntersectionRange(range, r).length != 0 {
                return r
            }
        }
        return .None
    }

    func rangeIntersectsWithArrayOfRanges(array: Array<NSRange>)(range: NSRange) -> Bool {
        for r in array {
            // "If the returned range’s length field is 0, then the two ranges don’t intersect"
            if NSIntersectionRange(range, r).length != 0 {
                return true
            }
        }
        return false
    }
    let rangeIntersectsWithRangesToInstrument = rangeIntersectsWithArrayOfRanges(rangesToInstrument)
    let linesToInstrument = linesInFile.filter {
        return rangeIntersectsWithRangesToInstrument(range: $0.rangeOfLineInContainingString)
    }

    let findOverlappingRangeInRangesToInstrument = findOverlappingRangeInArrayOfRanges(rangesToInstrument)
    let 😈 = linesInFile.map { (line) -> InstrumentableLine in
        let state: InstrumentableLine.InstrumentableState
        if contains(linesToInstrument, line) {
            let rangeThisLineIsPartOf = findOverlappingRangeInRangesToInstrument(range: line.rangeOfLineInContainingString)! // what if line overlaps end of one range and beginning of other? DOESN'T MATTER BECAUSE WE JUST CARE ABOUT THE LINE
            let intersectionRange = NSIntersectionRange(line.rangeOfLineInContainingString, rangeThisLineIsPartOf)
            let intersectionLocationRelativeToLine = intersectionRange.location - line.rangeOfLineInContainingString.location
            state = .Instrumentable(indexToInsertInstrumentationCode: intersectionLocationRelativeToLine) // this supports times when we might want to insert the instrumentation code in a function body that begins midway through a line
        } else {
            state = .NotInstrumentable
        }
        return InstrumentableLine(line: line, state: state)
    }
    func instrumentAnInstrumentableLine(instrumentableLine: InstrumentableLine) -> InstrumentableLine {
        switch instrumentableLine.state {
        case .Instrumentable(let index):
            let line = instrumentableLine.line
            let instrumentedLine = String.Line(lineNumber: line.lineNumber,
                lineContent: insertInstrumentationCodeAtIndex(index)(inString: line.lineContent),
                rangeOfLineInContainingString: line.rangeOfLineInContainingString, // todo: update range of line in containing string to reflect instrumentation
                containingString: line.containingString // todo: update containing string to contain instrumented line
            )
            return InstrumentableLine(line: instrumentableLine.line, state: .Instrumented(instrumentedLine: instrumentedLine))
        default:
            return instrumentableLine
        }
    }
    let x = 😈.map(instrumentAnInstrumentableLine)

    // Convert an array of Instrumented Lines into a string
    let instrumentedString = x.reduce("", combine: { (accum, instrumentableLine) -> String in
        switch instrumentableLine.state {
        case .Instrumented(let line):
            return accum + line.lineContent + "\n" //Todo: use the original delimiter, in case another line end format is used (this should work for compilation purposes, so v low priority
        case .Instrumentable, .NotInstrumentable:
            return accum + instrumentableLine.line.lineContent + "\n"
        }
    })
    // Convert an array of Instrumented Lines into a FileInstrumentationMap
    let instrumentationMap = x.reduce(FileInstrumentationMap(), combine: { (accum, line) -> FileInstrumentationMap in
        var ret = accum
        ret.append((line.line, ReducedInstrumentationState.fromInstrumentableState(line.state)))
        return ret
    })
    return (instrumentedString, instrumentationMap)
}

import Foundation
import SourceKittenFramework
import Argo
