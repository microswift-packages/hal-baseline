/// A protocol for clock select fields for timers.
public protocol ClockSelectField {
  /// The type of the tick frequency in the clock select field.
  associatedtype TickFrequency: ClockSelectTickFrequency

  /// The bit-width of the clock select field.
  static var bitWidth: UInt8 { get }

  /// The mask for the clock select field, with the least significant bit at the start of the mask.
  static var bitMask: UInt8 { get }

  /// Indicates the clock has no source, and the timer is stopped.
  static var stopped: Self { get }

  /// The bitfield value of the clock select field. It will be masked to the bit width of the field.
  var bitfieldValue: UInt8 { get }

  /// Initializes a clock select field from a bitfield value. It will be masked to the bit width of the field.
  init(bitfieldValue: UInt8)

  /// Initializes a clock select field from a tick frequency.
  init(ticks: TickFrequency)
}

extension ClockSelectField {
  /// The mask for the clock select field, with the least significant bit at the start of the mask.
  @inlinable @inline(__always)
  public static var bitMask: UInt8 {
    return UInt8.max >> (8 - bitWidth)
  }

  /// Initializes the clock select field from a tick frequency.
  @inlinable @inline(__always)
  public init(ticks: TickFrequency) {
    self.init(bitfieldValue: ticks.rawValue)
  }
}