/// A ``ClockSelectField`` for a 3-bit clock select field which provides an internal and external clock source.
public enum ClockSelect3BitWithExternal: ClockSelectField {

  public enum TickFrequency: UInt8, ClockSelectTickFrequency {
    /// The timer will tick every cycle of the internal clock.
    case everyCycle = 0x01

    /// The timer will tick every 8 cycles of the internal clock.
    case every8Cycles = 0x02

    /// The timer will tick every 64 cycles of the internal clock.
    case every64Cycles = 0x03

    /// The timer will tick every 256 cycles of the internal clock.
    case every256Cycles = 0x04

    /// The timer will tick every 1024 cycles of the internal clock.
    case every1024Cycles = 0x05
  }

  public enum ExternalTrigger: UInt8 {
    /// The timer will tick when the external clock goes from high to low.
    case onFallingEdge = 0x06

    /// The timer will tick when the external clock goes from low to high.
    case onRisingEdge = 0x07
  }

  /// The bit-width of the clock select field.
  public static let bitWidth: UInt8 = 3

  /// No clock source, the timer is stopped.
  case stopped

  /// The timer will tick based on the internal clock, at a specified frequency.
  case `internal`(tick: TickFrequency)

  /// The timer will tick based on an external clock attached to a specific pin, given the specified trigger.
  case external(tick: ExternalTrigger)

  /// Initializes a ``ClockSelect3BitWithExternal`` from a 3-bit bitfield value.
  @inlinable @inline(__always)
  public init(bitfieldValue: UInt8) {
    let bitfieldValue = bitfieldValue & Self.bitMask

    if let frequency = TickFrequency(rawValue: bitfieldValue) {
      self = .internal(tick: frequency)
    } else if let externalTrigger = ExternalTrigger(rawValue: bitfieldValue) {
      self = .external(tick: externalTrigger)
    } else {
      self = .stopped
    }
  }

  /// The 3-bit bitfield value of the clock source.
  @inlinable @inline(__always)
  public var bitfieldValue: UInt8 {
    switch self {
    case .stopped:
      return 0x00
    case .internal(let frequency):
      return frequency.rawValue
    case .external(let trigger):
      return trigger.rawValue
    }
  }
}
