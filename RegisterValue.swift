//===----------------------------------------------------------------------===//
//
// Register.swift
// Swift For Arduino
//
// Created by David Peterson.
//
//===----------------------------------------------------------------------===//

/// Values which can read from a register conform to this protocol.
public protocol RegisterValue {
  associatedtype RegisterType: FixedWidthInteger

  /// Initializes from the specified `UInt8` value.
  ///
  /// - Parameter registerValue: The `UInt8` value to initialize with.
  init(registerValue: RegisterType)

  /// Returns the current register value.
  var registerValue: RegisterType { get }
}

/// Values which can read and write to a register conform to this protocol.
public protocol MutableRegisterValue: RegisterValue {
  var registerValue: RegisterType { get set }
}

/// Utility functions for manipulating register values
extension RegisterValue {
  /// Checks if the `registerValue` has a value of `1` at the specified `index`.
  ///
  /// - Parameter index: The bit number between `0` and `7` to check.
  /// - Returns: `true` if the bit at the specified index is set to `1`.
  @inlinable @inline(__always)
  public func hasBit(at index: UInt8) -> Bool {
    // precondition(index < 8)
    return registerValue & (1 << index) != 0
  }

  /// Gets the bit value at the specified index. The result will always be `1` or `0`.
  ///
  /// - Parameter index: The index to retrieve from, between `0` and `7`.
  /// - Parameter type: The type to return. Defaults to the type of the value being assigned to.
  /// - Returns: The `1` or `0` value for the specified bit.
  @inlinable @inline(__always)
  public func getBit<T: FixedWidthInteger>(at index: UInt8, as type: T.Type = T.self) -> T {
    //        precondition(index < 8, "the indexed bit must be between 0 and 7.")
    return T(registerValue >> index) & 0b1
  }

  /// Gets the `RawRepresentable` with a `UInt8` `RawValue` that matches the bit at the specified index.
  /// The `RawRepresentable` is assumed to have valid values for `0` and `1`. If not, a `defaultValue` can be provided.
  ///
  /// This could be any `RawRepresentable`, but in practice this is typically an `enum` whose value type is `UInt8`. Eg:
  ///
  /// ```lua
  /// enum Active: UInt8 {
  ///     case inactive = 0
  ///     case active = 1
  /// }
  /// ```
  ///
  /// - Parameter index: The index to retrive from, between `0` and `7`.
  /// - Parameter defaultValue: The `RawRepresentable` value to use if none is found matching the bit value.
  /// - Returns: The `RawRepresentable` instance.
  @inlinable @inline(__always)
  public func getBit<T: RawRepresentable>(at index: UInt8, defaultValue: T? = nil) -> T
  where T.RawValue: FixedWidthInteger {
    //        precondition(index < 8, "the indexed bit must be between 0 and 7.")

    // return the value, or the default, or if all else fails, force the value
    guard let value = T(rawValue: getBit(at: index, as: T.RawValue.self)) ?? defaultValue else {
      fatalError()
    }
    return value
  }

  /// Reads the bits in the specified range and returns them as a ``RegisterType``, shifted to the right.
  ///
  /// - Parameter range: The `a...b` range (inclusive) to read bits from.
  /// - Parameter type: The type to return. Defaults to the type of the value being assigned to.
  /// - Returns: The bits, shifted to the right.
  @inlinable @inline(__always)
  public func getBits(from range: ClosedRange<Int>) -> RegisterType {
    //        precondition(range.lowerBound < 8, "the lower bound must be between 0 and 7.")
    //        precondition(range.upperBound < 8, "the upper bound must be between 0 and 7.")

    let mask = RegisterType.bitmask(from: range)
    return registerValue & mask >> range.lowerBound
  }

  /// Gets the `RawRepresentable` with a ``RegisterType`` `RawValue` that matches the bits at the specified index.
  /// The `RawRepresentable` is assumed to have valid values for all possible values within those bits.
  /// If not, a `defaultValue` can be provided, which will be used if there is a gap.
  ///
  /// This could be any `RawRepresentable`, but in practice this is typically an `enum` whose value type is `UInt8`. Eg:
  ///
  /// ```lua
  /// enum Options: UInt8 {
  ///     case zero = 0
  ///     case one = 1
  ///     case two = 2
  ///     case three = 3
  /// }
  ///
  /// registerValue = 0b00000100
  /// let option: Options = getBits(from: 2...3)) // `0b01`
  /// option == .one // true
  /// ```
  ///
  /// - Parameter range: The `a...b` range (inclusive) to read bits from.
  /// - Parameter defaultValue: The `RawRepresentable` value to use if none is found matching the bit value.
  /// - Returns: The `RawRepresentable` instance.
  /// - Throws: Fatal error if the range is outside `0` and `7`, or no matching value was found and no default provided.
  @inlinable @inline(__always)
  public func getBits<T: RawRepresentable>(from range: ClosedRange<Int>, defaultValue: T? = nil)
    -> T where T.RawValue == RegisterType
  {
    // return the value, or the default, or if all else fails, force the value
    guard let value = T(rawValue: getBits(from: range)) ?? defaultValue else {
      fatalError()
    }
    return value
  }
}

extension MutableRegisterValue {

  /// Sets the bit at the specified index to `1` if the `value` is `true`.
  ///
  /// - Parameter index: The index to set, between `0` and `7`.
  /// - Parameter value: The value.
  @inlinable @inline(__always)
  public mutating func setBit(at index: UInt8, to value: Bool) {
    // index is between 0 and 7
    //        precondition(index < 8, "the indexed bit must be between 0 and 7.")

    setBit(at: index, to: RegisterType(value ? 1 : 0))
  }

  /// Sets the bit at the specified index to the `Divalue`.
  ///
  /// - Parameter index: The index to set, between `0` and `7`.
  /// - Parameter value: The value.
  /// - Throws a fatal error if the index is out of range, or the value is greater than `1`.
  @inlinable @inline(__always)
  public mutating func setBit(at index: UInt8, to value: RegisterType) {
    //        precondition(index < 8, "the indexed bit must be between 0 and 7.")
    //        precondition(value <= 1, "the value must be 0 or 1.")

    registerValue = registerValue & ~(1 << index) | (value & 0b1) << index
  }

  /// Sets the bit at the specified index to the `rawValue` of the `RawRepresentable`
  ///
  /// - Parameter index: The index to set, between `0` and `7`.
  /// - Parameter value: The value.
  /// - Throws a fatal error if the index is out of range, or the `rawValue` is greater than `1`.
  @inlinable @inline(__always)
  public mutating func setBit<T: RawRepresentable>(at index: UInt8, to value: T)
  where T.RawValue == RegisterType {
    setBit(at: index, to: value.rawValue)
  }

  /// Sets the bits in the specified `range` to the provided `value`. Only the lowest-ranking bits
  /// from `value` matching the size of the `range` will be set - higher bits will be ignored.
  ///
  /// - Parameter range: The `a...b` range (inclusive) to read bits from.
  /// - Parameter value: The `UInt8` value to read bits from.
  @inlinable @inline(__always)
  public mutating func setBits(from range: ClosedRange<Int>, to value: RegisterType) {
    // all values are between 0 and 7
    //        precondition(range.lowerBound < 8, "the lower bound must be between 0 and 7.")
    //        precondition(range.upperBound < 8, "the upper bound must be between 0 and 7.")

    let mask = RegisterType.bitmask(from: range)
    let value = (value << range.lowerBound) & mask
    registerValue = registerValue & ~mask | value
  }

  /// Sets the bits in the specified `range` to the `rawValue` provided `RawRepresentable`.
  /// Only the lowest-ranking bits from `value` matching the size of the `range` will be set - higher bits will be ignored.
  ///
  /// - Parameter range: The `a...b` range (inclusive) to read bits from.
  /// - Parameter value: The `RawRepresentable` value to read bits from.
  @inlinable @inline(__always)
  public mutating func setBits<T: RawRepresentable>(from range: ClosedRange<Int>, to value: T)
  where T.RawValue == RegisterType {
    setBits(from: range, to: value.rawValue)
  }

  /// Inverts a bit of `registerValue` at the specified `index`.
  ///
  /// - Parameter index: The bit number between `0` and `7` to invert.
  @inlinable @inline(__always)
  public mutating func toggleBit(at index: UInt8) {
    // precondition(index < 8)
    registerValue ^= 1 << index
  }
}

extension RegisterValue where Self: FixedWidthInteger {
  /// Initializes the value to `1` or `0` for `true` or `false`, respectively.
  ///
  /// - Parameter value: The boolean value.
  @inlinable @inline(__always)
  public init(_ value: Bool) {
    self = value ? 1 : 0
  }

  /// Initialises the value based on a given register value.
  ///
  /// - Parameter registerValue: The register value.
  @inlinable @inline(__always)
  public init(registerValue: Self) {
    self = registerValue
  }

  /// The current register value.
  @inlinable @inline(__always)
  public var registerValue: Self {
    self
  }
}

extension MutableRegisterValue where Self: FixedWidthInteger {

  /// Initialises the value based on a given register value.
  ///
  /// - Parameter registerValue: The register value.
  @inlinable @inline(__always)
  public init(registerValue: Self) {
    self = registerValue
  }

  /// The current register value.
  @inlinable @inline(__always)
  public var registerValue: Self {
    @inlinable @inline(__always) get { self }
    @inlinable @inline(__always) set { self = newValue }
  }
}

extension UInt: RegisterValue, MutableRegisterValue {}
extension UInt8: RegisterValue, MutableRegisterValue {}
extension UInt16: RegisterValue, MutableRegisterValue {}
extension UInt32: RegisterValue, MutableRegisterValue {}
extension UInt64: RegisterValue, MutableRegisterValue {}

extension Int: RegisterValue, MutableRegisterValue {}
extension Int8: RegisterValue, MutableRegisterValue {}
extension Int16: RegisterValue, MutableRegisterValue {}
extension Int32: RegisterValue, MutableRegisterValue {}
extension Int64: RegisterValue, MutableRegisterValue {}

// MARK: RegisterBlock

/// A marker protocol for values which are safe to be read into
/// from multiple registers.
///
/// Implementors of this protocol will generally be structs that
/// contain the backing store for bytes read from registers.
///
/// They will also generally provide accessors for the particular data
/// represented in a given set of registers. Sometimes it will be
/// a multi-byte value, sometimes it will be flags or bits from a single byte.
///
/// Registers are populated directly into memory via `UnsafeRawBufferPointer`,
/// in the order that they occur in the register. This means that, for example,
/// if the register `0x01` is the high bit and `0x02` is the low bit of a 16-bit
/// integer, then they will be added into the value in that order, even though
/// most Swift platforms use little-endian formatting.
///
/// It will also do the same for signed values. For example, registers `0x01` to
/// `0x03` contains a signed, big-endian 24-bit number. There are no native 24-bit integers,
/// so we will read it into an `Int32`, which results in the first 3 bytes of the
/// `I2CRegisterBlock` being the high, mid, and low bytes, when it should be the reverse.
///
/// The ``I2CSlaveNode/read(from:withByteOrder:as)`` method will determine the
/// target ``FixedWidthInteger`` size, put convert the register order, and correctly
/// fill out the extra byte with either `0` or `1` values (depending on the sign value).
///
/// For this reason, it's recommended that structs containing multi-byte integer
/// values are initialised by reading the individual properties, rather than
/// as an `I2CRegisterBlock`.
public protocol RegisterBlock {}

/// A marker protocol that indicates that the type can be read from or written
/// to as a block of register bytes.
///
/// Implementors of this protocol will generally be structs that
/// contain the backing store for bytes read from registers.
///
/// They will also generally provide accessors for the particular data
/// represented in a given set of registers. Sometimes it will be
/// a multi-byte value, sometimes it will be flags or bits from a single byte.
///
/// Registers are populated directly into memory via `UnsafeMutableRawBufferPointer`,
/// in the order that they occur in the register. This means that, for example,
/// if the register `0x01` is the high bit and `0x02` is the low bit of a 16-bit
/// integer, then they will be added into the value in that order, even though
/// most Swift platforms use little-endian formatting.
///
/// The ``write(to:withByteOrder:value)`` method will determine the
/// target ``FixedWidthInteger`` size, put convert the register order, and correctly
/// fill out the extra byte with either `0` or `1` values (depending on the sign value).
///
/// For this reason, it's recommended that structs containing multi-byte integer
/// values are initialised by reading the individual properties, rather than
/// as an `RegisterBlock`.
public protocol MutableRegisterBlock: RegisterBlock {}

// MARK: Register Operations

/// Reads a ``UInt8` value from a register at the specified address.
///
/// - Parameter address: The address of the register to read.
/// - Returns: The value read from the register.
@inlinable @inline(__always)
public func _registerRead<R: RegisterValue>(address: PointerAddress) -> R
where R.RegisterType == UInt8 {
  R(registerValue: _volatileRegisterReadUInt8(address.rawValue))
}

/// Reads a ``UInt16` value from a register at the specified address.
///
@inlinable @inline(__always)
public func _registerRead<R: RegisterValue>(address: PointerAddress) -> R
where R.RegisterType == UInt16 {
  R(registerValue: _volatileRegisterReadUInt16(address.rawValue))
}

@inlinable @inline(__always)
public func _registerWrite<R: RegisterValue>(address: PointerAddress, value: R)
where R.RegisterType == UInt8 {
  _volatileRegisterWriteUInt8(address.rawValue, value.registerValue)
}

/// Writes a ``UInt16` value to a register at the specified address.
///
/// - Parameter address: The address of the register to write to.
/// - Parameter value: The value to write.
@inlinable @inline(__always)
public func _registerWrite<R: RegisterValue>(address: PointerAddress, value: R)
where R.RegisterType == UInt16 {
  _volatileRegisterWriteUInt16(address.rawValue, value.registerValue)
}

/// Reads a value from a register at the specified address.
///
/// - Parameter address: The address of the register to read.
/// - Parameter type: The type of the value to read.
/// - Returns: The value read from the register.
@inlinable @inline(__always)
public func _registerRead<R: RegisterValue>(address: PointerAddress, type: R.Type = R.self) -> R
where R.RegisterType == UInt8 {
  R(registerValue: _registerRead(address: address))
}

/// Reads a value from a register at the specified address.
///
/// - Parameter address: The address of the register to read.
/// - Parameter type: The type of the value to read.
/// - Returns: The value read from the register.
@inlinable @inline(__always)
public func _registerRead<R: RegisterValue>(address: PointerAddress, type: R.Type = R.self) -> R
where R.RegisterType == UInt16 {
  R(registerValue: _registerRead(address: address))
}

/// Writes a value to a register at the specified address.
///
/// - Parameter address: The address of the register to write to.
/// - Parameter value: The value to write.
@inlinable @inline(__always)
public func _registerWrite<R: MutableRegisterValue>(address: PointerAddress, value: R)
where R.RegisterType == UInt8 {
  _rawPointerWrite(address: address.intValue, value: value.registerValue)
}

/// Writes a value to a register at the specified address.
///
/// - Parameter address: The address of the register to write to.
/// - Parameter value: The value to write.
@inlinable @inline(__always)
public func _registerWrite<R: MutableRegisterValue>(address: PointerAddress, value: R)
where R.RegisterType == UInt16 {
  _rawPointerWrite(address: address.intValue, value: value.registerValue)
}

// @inlinable @inline(__always)
// public func _registerWriteUnstable<R: MutableRegisterValue>(address: PointerAddress, value: R) {
//   _rawPointerWrite(address: address.intValue, value: value.registerValue)
// }

// @inlinable @inline(__always)
// public func _registerBlockWriteUnstable<R: MutableRegisterBlock>(address: PointerAddress, value: R) {
//   _rawPointerWrite(address: address.intValue, value: value)
// }
