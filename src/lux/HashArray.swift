internal func hash<T: Hashable>(array: Array<T>) -> Int {
    return array.reduce(0) { accum, elem in
        return accum ^ elem.hashValue
    }
}
