/// A protocol for timer channels. It provides a common interface for 8-bit timer channels,
/// with functions for configuring the channel and reading the current count.
/// Timers have one or more channels, which are used to check the timer's counter value, and to
/// react to compare matches.
public protocol TimerChannel {

  /// The timer type.
  associatedtype Timer: TimerWithChannelA & TimerPeripheral

  associatedtype MatchInterrupt: Interrupt where MatchInterrupt.Source == Timer

  /// The timer's counter type.
  typealias Counter = Timer.Counter

  /// The compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static var compareValue: Counter { get set }
}
