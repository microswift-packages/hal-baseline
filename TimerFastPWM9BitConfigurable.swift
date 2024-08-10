/// A protocol that extends ``TimerPeripheral`` which can be configured in Fast or Phase-Correct PWM mode.
public protocol TimerFastPWM9BitConfigurable: TimerPeripheral {
  /// Configures the timer in Fast PWM mode. In this mode, the timer counts up until it overflows.
  /// When it overflows, the ``overflowTriggered`` is set, and the timer starts counting from `0` again.
  /// If an interrupt is enabled for the overflow, the interrupt will be triggered as well.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModeFastPWM9Bit(clock: ClockSelect)

  /// Checks if the timer is currently in 9-bit Fast PWM mode.
  @inlinable @inline(__always)
  static var isModeFastPWM9Bit: Bool { get }
}
