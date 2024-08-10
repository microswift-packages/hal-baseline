/// A pointer address, used for accessing memory-mapped registers.
public struct PointerAddress: RawRepresentable {
  /// This is an `Int` due to `_rawPointerRead/Write` requiring an `Int`. I feel like it should be a `UInt` at least? I'm not sure exactly what it's addressing though.
  @inline(__always)
  public let rawValue: UInt16
  
  /// Creates a `PointerAddress` from a raw unsigned integer value.
  @inlinable
  @inline(__always)
  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }

  /// The address, as an `Int`.
  @inlinable
  @inline(__always)
  var intValue: Int {
    Int(rawValue)
  }
}

extension PointerAddress: ExpressibleByIntegerLiteral {
  /// Constructs a `PointerAddress` from an integer literal.
  @inlinable @inline(__always)
  public init(integerLiteral value: UInt16) {
    self.rawValue = value
  }
}
