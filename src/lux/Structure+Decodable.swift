extension Structure: Decodable {
    static func decode(j: JSON) -> Decoded<Structure> {
        return Structure.create
            <^> j <|? "key.kind"
            <*> j <||? "key.substructure"
            <*> j <|? "key.bodyoffset"
            <*> j <|? "key.bodylength"
            <*> j <|? "key.offset"
    }

    static func create(kind: String?)(substructures: [Structure]?)(bodyOffset: Int?)(bodyLength: Int?)(offset: Int?) -> Structure {
        return Structure(kind: kind.flatMap { SwiftDeclarationKind(rawValue: $0) }, substructures: substructures ?? [], bodyOffset: bodyOffset, bodyLength: bodyLength, offset: offset)
    }
}

import Argo
import Runes
import SourceKittenFramework
