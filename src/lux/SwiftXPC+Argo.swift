extension JSON {
    // Literally copied and pasted from argo with the types changed a bit
    static func parse(d: XPCRepresentable) -> JSON {
        switch d {
        case let v as [XPCRepresentable]: return .Array(v.map(parse))

        case let v as [Swift.String: XPCRepresentable]:
            return .Object(reduce(v, [:]) { (var accum, elem) in
                let parsedValue = (self.parse <^> elem.1) ?? .Null
                accum[elem.0] = parsedValue
                return accum
                })

        case let v as Swift.String: return .String(v)
        case let v as Swift.Int64: return .Number(NSNumber(longLong: v))
        case let v as NSData: return .String(v.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros))
        default: assertionFailure("Unparseable type: \(d.dynamicType)"); return .Null
        }
    }
}

import Argo
import Runes
import SwiftXPC
