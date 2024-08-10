/// Represents a bitfield within a register.
public protocol Bitfield {
  /// The raw type of the bitfield.
  associatedtype BitfieldType: FixedWidthInteger

  /// The raw value of the bitfield.
  @inlinable @inline(__always)
  var bitfieldValue: BitfieldType { get }

  /// Create a bitfield from a raw value.
  @inlinable @inline(__always)
  init(bitfieldValue: BitfieldType)
}

// Allow any type that conforms to `FixedWidthInteger` to be a bitfield.
extension Bitfield where Self: FixedWidthInteger {
  /// The raw value of the bitfield.
  @inlinable @inline(__always)
  public var bitfieldValue: Self { self }

  /// Create a bitfield from a raw value.
  @inlinable @inline(__always)
  public init(bitfieldValue: Self) { self = bitfieldValue }
}

// Allow any `RawRepresentable` type that has a `FixedWidthInteger` raw value to be a bitfield.
extension Bitfield where Self: RawRepresentable, Self.RawValue: FixedWidthInteger {
  @inlinable @inline(__always)
  public var bitfieldValue: Self.RawValue { rawValue }

  @inlinable @inline(__always)
  public init(bitfieldValue: Self.RawValue) { self.init(rawValue: bitfieldValue)! }
}

// Conform the standard integer types to `Bitfield`.
extension UInt8: Bitfield {}
extension UInt16: Bitfield {}
extension UInt32: Bitfield {}
extension UInt64: Bitfield {}

// Conform the standard integer types to `Bitfield`.
extension Int8: Bitfield {}
extension Int16: Bitfield {}
extension Int32: Bitfield {}
extension Int64: Bitfield {}

// Conform boolean types to `Bitfield`.
extension Bool: Bitfield {
  @inlinable @inline(__always)
  public var bitfieldValue: UInt8 { self ? 1 : 0 }

  @inlinable @inline(__always)
  public init(bitfieldValue: UInt8) { self = bitfieldValue & 0x01 != 0 }

  @inlinable @inline(__always)
  public init(bitfieldValue: Bool) { self = bitfieldValue }
}

extension Bitfield where Self: RawRepresentable, Self.RawValue == Bool {
  @inlinable @inline(__always)
  public var bitfieldValue: UInt8 { rawValue ? 1 : 0 }

  @inlinable @inline(__always)
  public init(bitfieldValue: UInt8) { self.init(rawValue: bitfieldValue & 0x01 != 0)! }
}