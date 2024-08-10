/// A protocol that extends ``TimerPeripheral`` which can be configured in Phase- and Frequency-Correct PWM mode
/// with the top value at the timer's ``channelA/compareValue``.
public protocol TimerPhaseAndFrequencyCorrectPWMWithTopAtChannelAConfigurable: TimerPeripheral {
  /// Configures the timer in Phase- and Frequency-Correct PWM mode with the top value at the timer's
  /// ``channelA/compareValue``. In this mode, the timer counts up until it reaches the value in the ``channelA``'s
  /// ``compareValue``. When that happens, the ``channelA``'s ``interruptTriggered`` is set, and the timer starts
  /// counting down to `0x0` again.
  @inlinable @inline(__always)
  static func configureModePhaseAndFrequencyCorrectPWMWithTopAtChannelA(clock: ClockSelect)

  /// Checks if the timer is currently in Phase- and Frequency-Correct PWM mode with the top value at the timer's
  /// ``channelA/compareValue``.
  @inlinable @inline(__always)
  static var isModePhaseAndFrequencyCorrectPWMWithTopAtChannelA: Bool { get }
}
