/// The 4-bit prescale select field for the Watchdog Timer running on a 32kHz oscillator.
public enum WatchdogTimeoutAt32kHz: UInt8, WatchdogTimeoutField {
  /// Oscillator Cycles 512 (16 ms)
  case every512Cycles = 0x00
  /// Oscillator Cycles 1K (32 ms)
  case every1KCycles = 0x01
  /// Oscillator Cycles 2K (64 ms)
  case every2KCycles = 0x02
  /// Oscillator Cycles 4K (0.125 s)
  case every4KCycles = 0x03
  /// Oscillator Cycles 8K (0.25 s)
  case every8KCycles = 0x04
  /// Oscillator Cycles 16K (0.5 s)
  case every16KCycles = 0x05
  /// Oscillator Cycles 32K (1.0 s)
  case every32KCycles = 0x06
  /// Oscillator Cycles 64K (2.0 s)
  case every64KCycles = 0x07
  /// Oscillator Cycles 128K (4.0 s)
  case every128KCycles = 0x08
  /// Oscillator Cycles 256K (8.0 s)
  case every256KCycles = 0x09

  /// The bit-width of the prescale select field.
  public static var bitWidth: UInt8 { return 4 }

  /// The mask for the prescale select field, with the least significant bit at the start of the mask.
  public static var bitMask: UInt8 { return 0b00001111 }

  /// The bitfield value of the prescale select field. It will be masked to the bit width of the field.
  public var bitfieldValue: UInt8 { return rawValue }

  /// Initializes a prescale select field from a bitfield value. It will be masked to the bit width of the field.
  public init(bitfieldValue: UInt8) {
    self.init(rawValue: bitfieldValue & Self.bitMask)!
  }
}

// Add aliases for approximate time in seconds when the oscillator is running at 32 kHz.

extension WatchdogTimeoutAt32kHz {
  /// Around 16ms (every 512 cycles)
  public static let around16ms = Self.every512Cycles

  /// Around 32ms (every 1K cycles)
  public static let around32ms = Self.every1KCycles

  /// Around 64ms (every 2K cycles)
  public static let around64ms = Self.every2KCycles

  /// Around 125ms (every 4K cycles)
  public static let around125ms = Self.every4KCycles

  /// Around 250ms (every 8K cycles)
  public static let around250ms = Self.every8KCycles

  /// Around 500ms (every 16K cycles)
  public static let around500ms = Self.every16KCycles

  /// Around 1s (every 32K cycles)
  public static let around1s = Self.every32KCycles

  /// Around 2s (every 64K cycles)
  public static let around2s = Self.every64KCycles

  /// Around 4s (every 128K cycles)
  public static let around4s = Self.every128KCycles

  /// Around 8s (every 256K cycles)
  public static let around8s = Self.every256KCycles
}