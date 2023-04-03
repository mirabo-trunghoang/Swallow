//
// Copyright (c) Vatsal Manot
//

import Swift

infix operator ??=: AssignmentPrecedence
infix operator =??: AssignmentPrecedence

extension Optional {
    @inlinable
    public init(_ wrapped: @autoclosure () -> Wrapped, if condition: Bool) {
        self = condition ? wrapped() : nil
    }
    
    @inlinable
    public init(_ wrapped: @autoclosure () -> Optional<Wrapped>, if condition: Bool) {
        self = condition ? wrapped() : nil
    }
}

extension Optional {
    @inlinable
    public func map(into wrapped: inout Wrapped) {
        map { wrapped = $0 }
    }
    
    @inlinable
    public mutating func mutate<T>(_ transform: ((inout Wrapped) throws -> T)) rethrows -> T? {
        guard self != nil else {
            return nil
        }
        
        return try transform(&self!)
    }
    
    @inlinable
    public mutating func remove() -> Wrapped {
        defer {
            self = nil
        }
        
        return self!
    }
}

extension Optional {
    public static func ??= (lhs: inout Optional<Wrapped>, rhs: @autoclosure () -> Wrapped) {
        if lhs == nil {
            lhs = rhs()
        }
    }
    
    public static func ??= (lhs: inout Optional<Wrapped>, rhs: @autoclosure () -> Wrapped?) {
        if lhs == nil, let rhs = rhs() {
            lhs = rhs
        }
    }
    
    public static func =?? (lhs: inout Wrapped, rhs: Wrapped?) {
        if let rhs = rhs {
            lhs = rhs
        }
    }
    
    public static func =?? (lhs: inout Wrapped, rhs: Wrapped??) {
        lhs =?? rhs.compact()
    }
}

extension Optional {
    public func compact<T>() -> T? where Wrapped == T? {
        return self ?? .none
    }
    
    public func compact<T>() -> T? where Wrapped == T?? {
        return (self ?? .none) ?? .none
    }
    
    public func compact<T>() -> T? where Wrapped == T??? {
        return ((self ?? .none) ?? .none) ?? .none
    }
}

extension Optional {
    /// An error encountered while unwrapping an `Optional`.
    public enum UnwrappingError: CustomDebugStringConvertible, Error {
        case unexpectedlyFoundNil(at: SourceCodeLocation)
        
        public static var unexpectedlyFoundNil: Self {
            .unexpectedlyFoundNil(at: .unavailable)
        }
        
        public var debugDescription: String {
            switch self {
                case .unexpectedlyFoundNil(let location):
                    if location == .unavailable {
                        return "Unexpectedly found nil while unwrapping an \(String(describing: Optional<Wrapped>.self))."
                    } else {
                        return "Unexpectedly found nil while unwrapping an \(String(describing: Optional<Wrapped>.self)) value at \(location)."
                    }
            }
        }
    }
    
    @inlinable
    public func unwrapOrThrow(
        _ error: @autoclosure () throws -> Error
    ) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw try error()
        }
    }
}

#if DEBUG
extension Optional {
    /// Unwraps this `Optional`.
    ///
    /// - Throws: `UnwrappingError` if the instance is `nil`.
    /// - Returns: The unwrapped value of this instance.
    @inlinable
    public func unwrap(
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line,
        column: UInt = #column
    ) throws -> Wrapped {
        guard let wrapped = self else {
            throw UnwrappingError.unexpectedlyFoundNil(at: SourceCodeLocation(file: file, fileID: fileID, function: function, line: line, column: column))
        }
        
        return wrapped
    }
}
#else
extension Optional {
    /// Unwraps this `Optional`.
    ///
    /// - Throws: `UnwrappingError` if the instance is `nil`.
    /// - Returns: The unwrapped value of this instance.
    @inlinable
    public func unwrap() throws -> Wrapped {
        guard let wrapped = self else {
            throw UnwrappingError.unexpectedlyFoundNil(at: .unavailable)
        }
        
        return wrapped
    }
}
#endif

#if DEBUG
extension Optional {
    /// Force unwraps this `Optional`.
    @inlinable
    public func forceUnwrap(
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line,
        column: UInt = #column
    ) -> Wrapped {
        try! unwrap(file: file, line: line)
    }
}
#else
extension Optional {
    /// Force unwraps this `Optional`.
    @inlinable
    public func forceUnwrap() -> Wrapped {
        try! unwrap()
    }
}
#endif

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        map({ $0.isEmpty }) ?? true
    }
}

infix operator !! : NilCoalescingPrecedence

public func !!<T>(lhs: T?, rhs: String) -> T {
    guard let lhs else {
        fatalError(CustomStringError(description: rhs))
    }
    
    return lhs
}
