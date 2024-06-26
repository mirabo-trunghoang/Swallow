//
// Copyright (c) Vatsal Manot
//

import Swift

public struct AnyIdentifiable<ID>: Identifiable {
    public let base: any Identifiable<ID>
    
    public var id: AnyHashable {
        base.id.erasedAsAnyHashable
    }
    
    public init(erasing base: any Identifiable<ID>) {
        self.base = base
    }
}

public struct _ObjectIdentifierIdentified<Object>: Hashable {
    public let base: Object

    public var id: ObjectIdentifier {
        ObjectIdentifier(try! cast(base, to: AnyObject.self))
    }
    
    public init(_ base: Object) {
        self.base = base
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
}
