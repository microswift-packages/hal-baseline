/// An extension of ``Timer8BitPeripheral`` for 8-bit asynchronous timer peripherals.
/// It provides a common interface for 8-bit asynchronous timer peripherals,
/// with functions for configuring the timer and reading the current count.
public protocol Timer8BitAsyncPeripheral: Timer8BitPeripheral {
  
  /// Is the timer in asynchronous mode?
  @inlinable @inline(__always)
  static var isAsynchronous: Bool { get }

  /// Is the counter updating?
  @inlinable @inline(never)
  static var isCounterUpdating: Bool { get }

  /// Is the timer configuration updating?
  @inlinable @inline(never)
  static var isConfigurationUpdating: Bool { get }
}

/// An extension of Timer8BitAsyncPeripheral that supports an external
/// clock signal instead of a crystal.
public protocol Timer8BitAsyncExternalClockPeripheral: Timer8BitAsyncPeripheral {

  /// Are we using an external clock instead of a crystal?
  @inlinable @inline(__always)
  static var isUsingExternalClock: Bool { get }
  
  /// Configure the timer to use an external clock source. The clock should
  /// be connected to the TOSC1 pin.
  ///
  /// - Parameter ticks: The tick frequency on the external clock.
  @inlinable @inline(__always)
  static func configureExternalClock(ticks: ClockSelect.TickFrequency)

}
