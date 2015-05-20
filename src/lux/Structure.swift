// An improvement on the structure offered by SourceKittenFramework
// TODO: PR into sourcekitten https://github.com/swizzlr/lux/issues/21
struct Structure {
    let kind: SwiftDeclarationKind?
    let substructures: [Structure]
    // The byte length
    let bodyOffset: Int?
    // The byte length of the body of the structure, if it has a body
    let bodyLength: Int?
    // The byte offset of the beginning of the declaration, I believe
    let offset: Int?
}

import SourceKittenFramework
