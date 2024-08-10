/// A protocol for 16-bit synchronous timer peripherals. It provides a common interface for 16-bit timer peripherals,
/// with functions for configuring the timer and reading the current count.
public protocol Timer16BitPeripheral: Timer8BitPeripheral {
  /// The counter, as a 16-bit unsigned integer.
  static var counter16: UInt16 { get }
}

public extension Timer16BitPeripheral where Counter == UInt16 {
  /// The counter, as a 16-bit unsigned integer.
  @inlinable @inline(__always)
  static var counter16: UInt16 { Self.counter }
}