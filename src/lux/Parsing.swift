// Given a structure, walk all substructures and return a flat list of structures that are functions
func reduceFunctions(s: Structure) -> [Structure] {
    // Stolen from SwiftLint
    let functionKinds: [SwiftDeclarationKind] = [
        .FunctionAccessorAddress,
        .FunctionAccessorDidset,
        .FunctionAccessorGetter,
        .FunctionAccessorMutableaddress,
        .FunctionAccessorSetter,
        .FunctionAccessorWillset,
        .FunctionConstructor,
        .FunctionDestructor,
        .FunctionFree,
        .FunctionMethodClass,
        .FunctionMethodInstance,
        .FunctionMethodStatic,
        .FunctionOperator,
        .FunctionSubscript
    ]

    var functions: [Structure] = []
    if let kind = s.kind where contains(functionKinds, kind) {
        functions.append(s)
    }
    for substr in s.substructures {
        functions.extend(reduceFunctions(substr))
    }
    return functions
}

import SourceKittenFramework
