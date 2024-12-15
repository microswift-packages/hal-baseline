/// Minimal timer protocol, just a counter,
/// with functions for reading the current count.
public protocol MinimalTimerPeripheral {
  /// The counter register type.
  associatedtype Counter: FixedWidthInteger
  
  /// The counter register in its native size.
  @inlinable @inline(__always)
  static var counter: Counter { get }
}
