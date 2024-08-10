/// A ``ClockSelectField`` for a 4-bit clock select field which provides a fast clock source.
public enum ClockSelect4BitFast: ClockSelectField {
  public enum TickFrequency: UInt8, ClockSelectTickFrequency {
    /// The clock is updated 16 times per cycle.
    case times16PerCycle = 0x01
    /// The clock is updated 8 times per cycle.
    case times8PerCycle = 0x02
    /// The clock is updated 4 times per cycle.
    case times4PerCycle = 0x03
    /// The clock is updated 2 times per cycle.
    case times2PerCycle = 0x04
    /// The clock is updated every cycle.
    case everyCycle = 0x05
    /// The clock is updated every 2 cycles.
    case every2Cycles = 0x06
    /// The clock is updated every 4 cycles.
    case every4Cycles = 0x07
    /// The clock is updated every 8 cycles.
    case every8Cycles = 0x08
    /// The clock is updated every 16 cycles.
    case every16Cycles = 0x09
    /// The clock is updated every 32 cycles.
    case every32Cycles = 0x0A
    /// The clock is updated every 64 cycles.
    case every64Cycles = 0x0B
    /// The clock is updated every 128 cycles.
    case every128Cycles = 0x0C
    /// The clock is updated every 256 cycles.
    case every256Cycles = 0x0D
    /// The clock is updated every 512 cycles.
    case every512Cycles = 0x0E
    /// The clock is updated every 1024 cycles.
    case every1024Cycles = 0x0F
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

  /// The bitfield value of the clock select field.
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