public enum LuxError: ErrorType {
    case ReactiveTaskError(underlyingError: ReactiveTask.ReactiveTaskError)
    case NoOutputError
    case DataToStringError(underlyingData: NSData)
    case ReportingError
    case FailedToWriteJSONObject(obj: NSDictionary, underlyingError: NSError)

    public var nsError: NSError {
        get {
            return NSError()
        }
    }
}

import ReactiveCocoa
import ReactiveTask
