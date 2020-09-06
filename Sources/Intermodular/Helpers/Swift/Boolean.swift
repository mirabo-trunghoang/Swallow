//
// Copyright (c) Vatsal Manot
//

import Swift

/// A boolean type.
public protocol Boolean {
    /// The boolean representation of this value.
    var boolValue: Bool { get }
}

// MARK: - Extensions -

infix operator &&->: LogicalConjunctionPrecedence

extension Boolean {
    @inlinable
    public func then<T>(_ value: @autoclosure () throws -> T) rethrows -> T? {
        return boolValue ? try value() : nil
    }

    @discardableResult
    @inlinable
    public static func &&-> <T>(lhs: Self, rhs: @autoclosure () throws -> T) rethrows -> T? {
        return try lhs.then(rhs())
    }

    @inlinable
    public func then<T>(_ value: @autoclosure () throws -> T?) rethrows -> T? {
        return boolValue ? try value() : nil
    }

    @discardableResult @inlinable
    public static func &&-> <T>(lhs: Self, rhs: @autoclosure () throws -> T?) rethrows -> T? {
        return try lhs.then(rhs())
    }
}

infix operator ||>: LogicalDisjunctionPrecedence

extension Boolean {
    @inlinable
    public func or<T>(_ value: @autoclosure () throws -> T) rethrows -> T? {
        return !boolValue ? try value() : nil
    }

    @discardableResult
    @inlinable
    public static func ||> <T>(lhs: Self, rhs: @autoclosure () throws -> T) rethrows -> T? {
        return try lhs.or(rhs())
    }

    @inlinable
    public func or<T>(_ value: @autoclosure () throws -> T?) rethrows -> T? {
        return !boolValue ? try value() : nil
    }

    @discardableResult
    @inlinable
    public static func ||> <T>(lhs: Self, rhs: @autoclosure () throws -> T?) rethrows -> T? {
        return try lhs.or(rhs())
    }
}

infix operator &&=: AssignmentPrecedence
infix operator ||=: AssignmentPrecedence

extension Boolean {
    @inlinable
    public static func &&= (lhs: inout Self, rhs: @autoclosure () throws -> Self) rethrows {
        if lhs.boolValue {
            lhs = try rhs()
        }
    }

    @inlinable
    public static func ||= (lhs: inout Self, rhs: @autoclosure () throws -> Self) rethrows {
        if !lhs.boolValue {
            let rhs = try rhs()

            if rhs.boolValue {
                lhs = rhs
            }
        }
    }
}

// MARK: - Helpers -

extension BooleanInitiable {
    public init<T: Boolean>(boolean: T) {
        self.init(boolean.boolValue)
    }
}