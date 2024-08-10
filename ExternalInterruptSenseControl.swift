/// An ``ExternalInterrupt`` can be configured to trigger on rising, falling, or both edges.
///
/// | ISCn1 | ISCn0 | Description |
/// | ----- | ----- | ----------- |
/// | 0     | 0     | The low level of INTn generates an interrupt request. |
/// | 0     | 1     | Any logical change on INTn generates an interrupt request. |
/// | 1     | 0     | The falling edge of INTn generates an interrupt request. |
/// | 1     | 1     | The rising edge of INTn generates an interrupt request. |
public enum ExternalInterruptSenseControl: UInt8, Bitfield {
  case onLowLevel = 0b00
  case onAnyChange = 0b01
  case onFallingEdge = 0b10
  case onRisingEdge = 0b11

  /// Initializes a value from the raw value of the `ISCn0` bitfield.
  @inlinable @inline(__always)
  public init(bitfieldValue: UInt8) {
    self = (Self(rawValue: bitfieldValue) ?? .onLowLevel)
  }

  /// The bitfield value.
  @inlinable @inline(__always)
  public var bitfieldValue: UInt8 {
    rawValue
  }
}
