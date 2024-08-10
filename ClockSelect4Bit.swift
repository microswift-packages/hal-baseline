/// A ``ClockSelectField`` for a 4-bit clock select field which provides an clock source.
public enum ClockSelect4Bit: ClockSelectField {
  public enum TickFrequency: UInt8, ClockSelectTickFrequency {
    case everyCycle = 0x01
    case every2Cycles = 0x02
    case every4Cycles = 0x03
    case every8Cycles = 0x04
    case every16Cycles = 0x05
    case every32Cycles = 0x06
    case every64Cycles = 0x07
    case every128Cycles = 0x08
    case every256Cycles = 0x09
    case every512Cycles = 0x0A
    case every1024Cycles = 0x0B
    case every2048Cycles = 0x0C
    case every4096Cycles = 0x0D
    case every8192Cycles = 0x0E
    case every16384Cycles = 0x0F
  }

  /// The bit-width of the clock select field.
  public static let bitWidth: UInt8 = 4

  /// No clock source, the timer is stopped.
  case stopped

  /// The timer will tick based on the internal clock, at a specified frequency.
  case `internal`(tick: TickFrequency)

  /// Initializes a ``ClockSelect4Bit`` from a 4-bit bitfield value.
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