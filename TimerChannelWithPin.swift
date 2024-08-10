/// A protocol for ``TimerChannel`` types that are connected to a physical pin.
/// These can often be represented as ``OutputComparePin`` or ``PWMPin``.
/// For the latter, they may be represented as 8-bit, 9-bit, or 10-bit ``PWMPin``s.
/// This protocol just provides the configuration options for the channel.
/// You can discover specific pin implementations using protocols like ``HasOutputComparePin`` and ``HasPWM10BitPin``.
public protocol TimerChannelWithPin: TimerChannel {
  /// The effect that a compare match has on the output pin.
  @inlinable @inline(__always)
  static var outputPinEffect: OutputComparePinEffect { get set }

  /// Attempts to force a compare match using the ``TimerChannel/compareValue``.
  /// Only works if the ``TimerChannel/timer`` is currently in an `immediate` update mode (ie. not PWM).
  ///
  /// - Returns: `true` if the compare match was forced, `false` otherwise.
  @inlinable @inline(__always)
  static func forceCompareMatch() -> Bool
}