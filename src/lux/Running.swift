private func executeTestCommand(command: String) -> SignalProducer<NSData, ReactiveTaskError> {
    let testCommand = TaskDescription(launchPath: "/bin/bash",
        arguments: ["-c", command])
    return launchTask(testCommand)
}

public func executeAndParseTestCommand(command: String) -> Result<CountedSet<LineIdentifier>, LuxError>? {
    return executeTestCommand(command)
        |> mapError { LuxError.ReactiveTaskError(underlyingError: $0) }
        |> flatMap(.Concat) { data -> SignalProducer<String, LuxError> in
            return SignalProducer<String, LuxError>(result: Result(NSString(data: data, encoding: NSUTF8StringEncoding) as String?, failWith: LuxError.DataToStringError(underlyingData: data)))
        }
        |> flatMap(.Concat) { string in
            return string.linesProducer |> promoteErrors(LuxError.self)
        }
        |> filter { ($0 as NSString).rangeOfString(MagicDelimiter).location != NSNotFound }
        |> map { line -> LineIdentifier in
            let coms = (line as NSString).componentsSeparatedByString(MagicDelimiter)
            return LineIdentifier(filename: coms[1] as! String, lineNumber: (coms[2] as! NSString).integerValue)
        }
        |> reduce(CountedSet<LineIdentifier>()) { (set, line) -> CountedSet<LineIdentifier> in
            var ret = set
            ret.insert(line)
            return ret
        }
        |> single
}

import ReactiveTask
import ReactiveCocoa
import Result
