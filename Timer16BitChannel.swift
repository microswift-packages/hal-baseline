/// A protocol for a channel on a 16-bit synchronous timer peripherals.
public protocol Timer16BitChannel: Timer8BitChannel {
  /// The 16-bit compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static var compareValue16: UInt16 { get set }
}

public extension Timer16BitChannel where Counter == UInt16 {
  /// The 16-bit compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static var compareValue16: UInt16 {
    get { Self.compareValue }
    set { Self.compareValue = newValue }
  }
}