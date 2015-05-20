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
}
