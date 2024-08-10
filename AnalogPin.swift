/// An analog pin on a microcontroller.
///
/// Analog pins are typically used to read analog values from sensors, such as light sensors, temperature sensors, etc.
public protocol AnalogPin {
  /// Reads the analog value from the pin (usually a 10-bit value from `0` to `1023`).
  @inlinable @inline(__always)
  static var value: UInt16 { get }
}
