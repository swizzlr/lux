// Increase the API surface as you like; this is minimally sufficient for my needs.

public struct CountedSet<T : Hashable> {
    private var underlyingSet: Set<T> = Set<T>()
    private var countIndex: Dictionary<T, Int> = Dictionary<T, Int>()
    public init() { }
    public mutating func insert(member: T) {
        underlyingSet.insert(member)
        if let i = countIndex[member] {
            countIndex[member] = (i + 1)
        } else {
            countIndex[member] = 1
        }
    }
    public subscript(elem: T) -> (element: T, count: Int)? {
        return underlyingSet.indexOf(elem)
            .map { underlyingSet[$0] }
            .map { (element: $0, count: countIndex[$0]!) }
    }
}

extension CountedSet: ArrayLiteralConvertible {
    typealias Element = T
    public init(arrayLiteral elements: Element...) {
        for elem in elements {
            self.insert(elem)
        }
    }
}
