/// A protocol that extends ``Timer8BitWithChannelA`` which can be configured in Fast PWM with Top at OCRnA mode.
public protocol TimerFastPWMWithTopAtChannelAConfigurable: TimerPeripheral {
  /// Configures the timer in Fast PWM with Top at Channel A mode. In this mode, the timer counts up until it reaches
  /// the value in the ``channelA``'s ``compareValue``. When that happens, the ``channelA``'s
  /// ``ChannelA/onMatch/triggered`` value is set, and the timer starts counting from `0` again.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModeFastPWMWithTopAtChannelA(clock: ClockSelect)

  /// Checks if the timer is currently in Fast PWM with Top at Channel A mode.
  @inlinable @inline(__always)
  static var isModeFastPWMWithTopAtChannelA: Bool { get }
}
