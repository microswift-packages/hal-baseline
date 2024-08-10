/// A protocol that extends ``TimerPeripheral`` which can be configured in Phase-Correct PWM mode with a `top`
/// defined by the ``InputCapture/value``.
public protocol TimerPhaseCorrectPWMWithTopAtInputCaptureConfigurable: TimerPeripheral {
  /// Configures the timer in Phase Correct PWM mode with a `top` defined by the ``InputCapture/value``.
  /// In this mode, the timer counts up until it hits the value defined by the ``InputCapture/value``,
  /// then it counts down until it hits `0`. When that happens, the ``overflowTriggered`` is set, and the timer starts
  /// counting from `0` again. If an interrupt is enabled for the overflow, the interrupt will be triggered as well.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModePhaseCorrectPWMWithTopAtInputCapture(clock: ClockSelect)

  /// Checks if the timer is currently in Phase Correct PWM mode with a `top` defined by the ``InputCapture/value``.
  @inlinable @inline(__always)
  static var isModePhaseCorrectPWMWithTopAtInputCapture: Bool { get }
}
