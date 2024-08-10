/// Represents a variant of a microcontroller.
public protocol Variant {
  /// The type of the chip that the variant is for.
  associatedtype Chip: HAL.Chip

  /// The human-readable order code.
  @inlinable @inline(__always)
  static var orderCode: StaticString { get }

  /// The package name.
  @inlinable @inline(__always)
  static var package: StaticString { get }

  /// The minimum operating temperature in degrees Celsius.
  @inlinable @inline(__always)
  static var tempMin: Int { get }

  /// The maximum operating temperature in degrees Celsius.
  @inlinable @inline(__always)
  static var tempMax: Int { get }

  /// The maximum operating speed in Hz.
  @inlinable @inline(__always)
  static var speedMax: Frequency { get }

  /// The minimum operating voltage in volts.
  @inlinable @inline(__always)
  static var vccMin: Float { get }

  /// The maximum operating voltage in volts.
  @inlinable @inline(__always)
  static var vccMax: Float { get }

  /// The pinout name of the variant.
  @inlinable @inline(__always)
  static var pinout: StaticString? { get }
}