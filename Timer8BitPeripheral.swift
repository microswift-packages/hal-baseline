
/// A protocol for 8-bit synchronous timer peripherals. It provides a common interface for 8-bit timer peripherals,
/// with functions for configuring the timer and reading the current count.
public protocol Timer8BitPeripheral: TimerPeripheral {
  /// The counter, as an 8-bit unsigned integer.
  static var counter8: UInt8 { get }
}

public extension Timer8BitPeripheral where Counter == UInt8 {
  /// The counter, as an 8-bit unsigned integer.
  @inlinable @inline(__always)
  static var counter8: UInt8 { Self.counter }
}

public extension Timer8BitPeripheral where Counter == UInt16 {
  /// The counter, as an 8-bit unsigned integer.
  @inlinable @inline(__always)
  static var counter8: UInt8 { UInt8(truncatingIfNeeded: Self.counter) }
}