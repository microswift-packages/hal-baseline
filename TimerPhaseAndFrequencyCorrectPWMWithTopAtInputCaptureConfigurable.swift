/// A protocol that extends ``TimerPeripheral`` which can be configured in Phase- and Frequency-Correct PWM mode
/// with the top value at the timer's ``inputCapture/value``.
public protocol TimerPhaseAndFrequencyCorrectPWMWithTopAtInputCaptureConfigurable: TimerPeripheral {
  /// Configures the timer in Phase- and Frequency-Correct PWM mode with the top value at the timer's
  /// ``inputCapture/value``. In this mode, the timer counts up until it reaches the value in the ``inputCapture``'s
  /// ``value``. When that happens, the ``inputCapture``'s ``interruptTriggered`` is set, and the timer starts
  /// counting down to `0x0` again.
  @inlinable @inline(__always)
  static func configureModePhaseAndFrequencyCorrectPWMWithTopAtInputCapture(clock: ClockSelect)

  /// Checks if the timer is currently in Phase- and Frequency-Correct PWM mode with the top value at the timer's
  /// ``inputCapture/value``.
  @inlinable @inline(__always)
  static var isModePhaseAndFrequencyCorrectPWMWithTopAtInputCapture: Bool { get }
}
