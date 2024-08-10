infix operator ??= : AssignmentPrecedence

/// Assigns the right-hand side to the left-hand side if the right-hand side is not `nil`.
/// 
/// For example:
/// 
/// ```swift
/// struct Foo {
///   var bar: Int
///   func update(bar: Int?) {
///     self.bar ??= bar
///   }
/// }
/// ```
///
/// In this case, `self.bar` will be updated to `bar` if `bar` is not `nil`.
/// This is almost equivalent to just using `self.bar = bar ?? self.bar`, but in some cases,
/// assigning `nil` (or any value) to `self.bar` may have side effects.
/// This operator is useful when you want to avoid those side effects.
///
/// - Parameters:
///   - left: The left-hand side.
///   - right: The right-hand side.
@inlinable @inline(__always)
public func ??=<T>(left: inout T, right: T?) {
    if let nonNilRight = right {
        left = nonNilRight
    }
}

/// Assigns the right-hand side to the left-hand side if the right-hand side is not `nil`.
/// 
/// For example:
/// 
/// ```swift
/// struct Foo {
///   var bar: Int?
///   func update(bar: Int?) {
///     self.bar ??= bar
///   }
/// }
/// ```
///
/// In this case, `self.bar` will be updated to `bar` if `bar` is not `nil`.
/// This is almost equivalent to just using `self.bar = bar`, but in some cases,
/// assigning `nil` (or any value) to `self.bar` may have side effects.
/// This operator is useful when you want to avoid those side effects.
///
/// - Parameters:
///   - left: The left-hand side.
///   - right: The right-hand side.
@inlinable @inline(__always)
public func ??=<T>(left: inout T?, right: T?) {
    if let nonNilRight = right {
        left = nonNilRight
    }
}
