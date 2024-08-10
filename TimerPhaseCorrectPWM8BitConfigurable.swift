/// A protocol that extends ``TimerPeripheral`` which can be configured in 8-bit Phase-Correct PWM mode.
public protocol TimerPhaseCorrectPWM8BitConfigurable: TimerPeripheral {
  /// Configures the timer in 8-bit Phase Correct PWM mode. In this mode, the timer counts up until it hits `0xFF` (`max`),
  /// then it counts down until it hits `0`. When that happens, the ``overflowTriggered`` is set, and the timer starts
  /// counting from `0` again. If an interrupt is enabled for the overflow, the interrupt will be triggered as well.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModePhaseCorrectPWM8Bit(clock: ClockSelect)

  /// Checks if the timer is currently in 8-bit Phase Correct PWM mode.
  @inlinable @inline(__always)
  static var isModePhaseCorrectPWM8Bit: Bool { get }
}
