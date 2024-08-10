/// A protocol that extends ``TimerPeripheral`` which can be configured in 9-bit Phase-Correct PWM mode.
public protocol TimerPhaseCorrectPWM9BitConfigurable: TimerPeripheral {
  /// Configures the timer in 9-bit Phase Correct PWM mode. In this mode, the timer counts up until it hits `0x1FF`,
  /// then it counts down until it hits `0`. When that happens, the ``overflowTriggered`` is set, and the timer starts
  /// counting from `0` again. If an interrupt is enabled for the overflow, the interrupt will be triggered as well.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModePhaseCorrectPWM9Bit(clock: ClockSelect)

  /// Checks if the timer is currently in 9-bit Phase Correct PWM mode.
  @inlinable @inline(__always)
  static var isModePhaseCorrectPWM9Bit: Bool { get }
}
