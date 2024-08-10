/// A protocol for a channel on an 8-bit synchronous timer peripherals.
public protocol Timer8BitChannel: TimerChannel {
  /// The 8-bit compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static var compareValue8: UInt8 { get set }
}

public extension Timer8BitChannel where Counter == UInt8 {
  /// The 8-bit compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static var compareValue8: UInt8 {
    get { Self.compareValue }
    set { Self.compareValue = newValue }
  }
}

public extension Timer8BitChannel where Counter == UInt16 {
  /// The 8-bit compare value. This is continuously compared to
  /// the ``timer``'s ``Timer/counter`` register based on the ``timer``'s mode, and
  /// the ``timer``'s output is toggled depending on the ``outputPinEffect``.
  @inlinable @inline(__always)
  static var compareValue8: UInt8 {
    get { UInt8(truncatingIfNeeded: Self.compareValue) }
    set { Self.compareValue = UInt16(newValue) }
  }
}