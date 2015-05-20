// Full documentation for coveralls report format: 
// https://coveralls.zendesk.com/hc/en-us/articles/201774865-API-Introduction

public enum RepositoryReferenceStrategy {
    case Token(repoToken: String)
    case KnownService(serviceName: String, jobID: String)
}

/// Produces a JSON coveralls report
public func reportCoveralls(strategy: RepositoryReferenceStrategy)
    (report: CoverageReport) -> Result<NSData, LuxError> {
    return Result.success(Dictionary<NSString, AnyObject>())
        >>- lift(coverallsSourceFiles(report))
        >>- lift(coverallsRepoReference(strategy))
        >>- lift(eraseType)
        >>- toJSON
}

private func eraseType(dict: Dictionary<NSString, AnyObject>) -> NSDictionary {
    return dict as NSDictionary
}

private func toJSON(dict: NSDictionary) -> Result<NSData, LuxError> {
    var error: NSError?
    return Result(NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: &error), failWith: LuxError.FailedToWriteJSONObject(obj: dict, underlyingError: error!))
}

/// Add the `source_files` array of objects to a supplied dictionary
private func coverallsSourceFiles(report: CoverageReport)(dict: Dictionary<NSString, AnyObject>)
     -> Dictionary<NSString, AnyObject> {
    var ret = dict
    ret["source_files"] = map(report.files) {
        var sourceFileDict = Dictionary<NSString, AnyObject>()
        sourceFileDict["name"] = $0.file.path!
        sourceFileDict["source"] = $0.originalContents
        sourceFileDict["coverage"] = $0.lineReports.map { report -> AnyObject in
            switch report {
            case .NotInstrumented:
                return NSNull()
            case .Instrumented(let hitCount):
                return NSNumber(integer: hitCount)
            }
            } as NSArray
        return sourceFileDict
    } as Array<Dictionary<NSString, AnyObject>> as NSArray // persuade compiler 
                                            // to infer correct types for `map`
    return ret
}

/// Add the repository reference strategy to a supplied dictionary
private func coverallsRepoReference(strategy: RepositoryReferenceStrategy)(dict: Dictionary<NSString, AnyObject>)
     -> Dictionary<NSString, AnyObject> {
    var ret = dict
    switch strategy {
    case .Token(let token):
        ret["repo_token"] = token as NSString
    case .KnownService(let serviceName, let jobID):
        ret["service_job_id"] = jobID as NSString
        ret["service_name"] = serviceName as NSString
    }
    return ret
}

/// Converts a map function into a flatMap function.
private func lift<T, U, Error>(mapTransform: T -> U) -> (T -> Result<U, Error>){
    return {
        return Result.success(mapTransform($0))
    }
}

import Result
