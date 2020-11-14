//
// Copyright (c) Vatsal Manot
//

import Swift

public enum Trilean: Int8, Hashable {
    case `false` = -1
    case unknown
    case `true`
}

// MARK: - Protocol Conformances -

extension Trilean: Boolean {
    @inlinable
    public var boolValue: Bool {
        return value ?? false
    }
}

extension Trilean: CustomStringConvertible {
    @inlinable
    public var description: String {
        switch self {
            case .false:
                return "false"
            case .unknown:
                return "unknown"
            case .true:
                return "true"
        }
    }
}

extension Trilean: ExpressibleByBooleanLiteral {
    @inlinable
    public init(booleanLiteral value: Bool) {
        self = value ? .true : .false
    }
}

extension Trilean: MutableWrapper {
    @inlinable
    public var value: Bool? {
        get {
            switch self {
                case .true:
                    return true
                case .false:
                    return false
                
                default:
                    return nil
            }
        } set {
            self = newValue.map({ $0 ? .true : .false }) ?? .unknown
        }
    }
    
    public init(_ value: Bool?) {
        self = value.map({ $0 ? .true : .false }) ?? .unknown
    }
}

// MARK: - Auxiliary Extensions -

extension Trilean {
    @inlinable
    public static prefix func ! (rhs: Trilean) -> Trilean {
        return .init(rhs.value.map(!))
    }
    
    @inlinable
    public static func && (lhs: Trilean, rhs: Trilean) -> Trilean {
        return (lhs == false || rhs == false) ? false : ((lhs == .unknown || rhs == .unknown) ? .unknown : true)
    }
    
    @inlinable
    public static func || (lhs: Trilean, rhs: Trilean) -> Trilean {
        return (lhs == true || rhs == true) ? true : ((lhs == .unknown || rhs == .unknown) ? .unknown : false)
    }
}

// MARK: - Helpers -

public let unknown: Trilean = .unknown
