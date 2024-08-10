/// A protocol for timers that have a Channel A.
public protocol TimerWithChannelA: TimerPeripheral {
  /// The type of the timer's "A" channel.
  associatedtype ChannelA: TimerChannel where ChannelA.Timer == Self

  /// Configures the timer in Clear Timer on Compare (CTC) mode. When in this mode, the timer counts up until it
  /// reaches the value in the ``channelA``'s ``compareValue``. When that happens, the ``channelA``'s
  /// ``interruptTriggered`` is set, and the timer starts counting from `0` again.
  ///
  /// - Parameter clock: The clock source/configuration for the timer.
  @inlinable @inline(__always)
  static func configureModeCTC(clock: ClockSelect, top: ChannelA.Counter)

  /// Checks if the timer is currently in Clear Timer on Compare (CTC) mode.
  @inlinable @inline(__always)
  static var isModeCTC: Bool { get }
}
