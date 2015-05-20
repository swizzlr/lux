extension File: Equatable {}
public func ==(lhs: File, rhs: File) -> Bool {
    return (lhs.contents == rhs.contents) && (lhs.path == rhs.path)
}
extension File: Hashable {
    public var hashValue: Int {
        get {
            return contents.hashValue ^ (path?.hashValue ?? 0)
        }
    }
}

import SourceKittenFramework