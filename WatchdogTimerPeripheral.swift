/// A peripheral for the Watchdog Timer.
///
/// The Watchdog Timer is a peripheral that can be used to detect and recover from software faults.
///
/// It can be configured to reset the system after a given timeout period.
public protocol WatchdogTimerPeripheral {
  /// The prescale select field type.
  associatedtype TimeoutField: WatchdogTimeoutField

  /// The number of cycles to wait before timing out.
  @inlinable @inline(__always)
  static var timeout: TimeoutField { get }

  /// Will the Watchdog Timer reset the system when it times out?
  @inlinable @inline(__always)
  static var systemResetEnabled: Bool { get }

  /// Configures the timer to be stopped.
  @inlinable @inline(__always)
  static func configureStopped()

  /// Configures the timer to perform a system reset after the timeout.
  ///
  /// - Parameters:
  ///   - timeout: The number of cycles to wait before timing out.
  @inlinable @inline(__always)
  static func configureSystemReset(after timeout: TimeoutField)

  /// Resets the timer.
  @inlinable @inline(__always)
  static func reset()
}