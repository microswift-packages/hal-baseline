/// A protocol that extends ``Timer8BitWithChannelA`` which can be configured in Phase-Correct PWM with Top at OCRnA mode.
public protocol TimerPhaseCorrectPWMWithTopAtChannelAConfigurable: TimerPeripheral {
  /// Configures the timer in Phase Correct PWM with Top at Channel A mode. In this mode, the timer counts up until it
  /// reaches the value in the ``channelA``'s ``compareValue``. When that happens, the ``channelA``'s
  /// ``interruptTriggered`` is set, and the timer starts counting down from `0xFF` again.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModePhaseCorrectPWMWithTopAtChannelA(clock: ClockSelect)

  /// Checks if the timer is currently in Phase Correct PWM with Top at Channel A mode.
  @inlinable @inline(__always)
  static var isModePhaseCorrectPWMWithTopAtChannelA: Bool { get }
}
