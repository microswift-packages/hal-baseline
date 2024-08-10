/// A peripheral for the Watchdog Timer.
///
/// The Watchdog Timer is a peripheral that can be used to detect and recover from software faults.
/// You can define a timeout period from an independent clock source (typically running at either 128kHz or 32kHz),
/// and if the Watchdog Timer is not reset before the timeout period expires, the Watchdog Timer will either
/// reset the device, generate an interrupt, or both.
public protocol WatchdogTimerWithInterrupt: WatchdogTimerPeripheral {
  /// The interrupt type.
  associatedtype TimeoutInterrupt: Interrupt

  /// Configures the timer to trigger an interrupt after the timeout.
  ///
  /// - Parameters:
  ///   - timeout: The number of cycles to wait before timing out.
  ///   - handler: The interrupt handler.
  static func configureInterrupt(after timeout: TimeoutField, handler: @escaping InterruptHandler)

  /// Configures the timer to trigger an interrupt then a system reset after the timeout.
  ///
  /// - Parameters:
  ///   - timeout: The number of cycles to wait before timing out.
  ///   - handler: The interrupt handler.
  static func configureInterruptAndSystemReset(after timeout: TimeoutField, handler: @escaping InterruptHandler)
}