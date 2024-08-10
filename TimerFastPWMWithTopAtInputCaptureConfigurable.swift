/// A protocol that extends ``TimerProtocol`` which can be configured in Fast PWM with Top at ``InputCapture/value`` mode.
public protocol TimerFastPWMWithTopAtInputCaptureConfigurable: TimerPeripheral {
  /// Configures the timer in Fast PWM with Top at ``InputCapture/value``. In this mode, the timer counts up until it reaches
  /// the value in the ``inputCapture``'s ``value``.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModeFastPWMWithTopAtInputCapture(clock: ClockSelect)

  /// Checks if the timer is currently in Fast PWM with Top at Channel A mode.
  @inlinable @inline(__always)
  static var isModeFastPWMWithTopAtInputCapture: Bool { get }
}
