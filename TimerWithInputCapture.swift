/// A protocol for ``TimerPeripheral``s that have a ``TimerInputCapture`` unit.
public protocol TimerWithInputCapture: TimerPeripheral {
  /// The type of the timer's "B" channel.
  associatedtype InputCapture: TimerInputCapture where InputCapture.Timer == Self
}
