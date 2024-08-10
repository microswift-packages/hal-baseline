/// Extensions of the channel on an 8-bit asynchronous timer.
public protocol Timer8BitAsyncChannel: TimerChannel
  where Timer: Timer8BitAsyncPeripheral
{
  /// Is the output compare register update busy?
  @inlinable @inline(__always)
  static var isCompareValueUpdating: Bool { get }
}