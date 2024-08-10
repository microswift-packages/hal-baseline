/// A protocol for ``TimerPeripheral``s that have a Channel C.
public protocol TimerWithChannelC: TimerWithChannelB {
  /// The type of the timer's "B" channel.
  associatedtype ChannelC: TimerChannel where ChannelC.Timer == Self
}
