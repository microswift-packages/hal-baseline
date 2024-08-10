/// A protocol for ``TimerPeripheral``s that have a Channel B.
public protocol TimerWithChannelB: TimerWithChannelA {
  /// The type of the timer's "B" channel.
  associatedtype ChannelB: TimerChannel where ChannelB.Timer == Self
}
