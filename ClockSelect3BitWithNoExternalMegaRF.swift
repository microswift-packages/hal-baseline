/// A ``ClockSourceField`` for a 3-bit clock select field which provides an internal clock source with limited prescaler options.
/// This is used by the ATmegaRF family of MCUs.
public enum ClockSelect3BitWithNoExternalMegaRF: ClockSelectField {

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

  /// The bit-width of the clock select field.
  public static let bitWidth: UInt8 = 3

  /// No clock source, the timer is stopped.
  case stopped

  /// The timer will tick based on the internal clock, at a specified frequency.
  case `internal`(tick: TickFrequency)

  /// Initializes a ``ClockSelect3Bit`` from a 3-bit bitfield value.
  @inlinable @inline(__always)
  public init(bitfieldValue: UInt8) {
    let bitfieldValue = bitfieldValue & Self.bitMask

    if let frequency = TickFrequency(rawValue: bitfieldValue) {
      self = .internal(tick: frequency)
    } else {
      self = .stopped
    }
  }

  /// The bitfield value of the clock select field. It will be masked to the bit width of the field.
  @inlinable @inline(__always)
  public var bitfieldValue: UInt8 {
    switch self {
    case .stopped:
      return 0x00
    case .internal(let tick):
      return tick.rawValue
    }
  }
}