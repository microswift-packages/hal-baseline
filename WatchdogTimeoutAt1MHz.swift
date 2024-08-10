/// The 3-bit prescale select field for the Watchdog Timer.
public enum WatchdogTimeoutAt1MHz: UInt8, WatchdogTimeoutField {
  /// Oscillator Cycles 16K
  case every16KCycles = 0x00
  /// Oscillator Cycles 32K
  case every32KCycles = 0x01
  /// Oscillator Cycles 64K
  case every64KCycles = 0x02
  /// Oscillator Cycles 128K
  case every128KCycles = 0x03
  /// Oscillator Cycles 256K
  case every256KCycles = 0x04
  /// Oscillator Cycles 512K
  case every512KCycles = 0x05
  /// Oscillator Cycles 1024K
  case every1024KCycles = 0x06
  /// Oscillator Cycles 2048K
  case every2048KCycles = 0x07

  /// The bit-width of the prescale select field.
  @inlinable @inline(__always)
  public static var bitWidth: UInt8 { return 3 }

  /// The mask for the prescale select field, with the least significant bit at the start of the mask.
  @inlinable @inline(__always)
  public static var bitMask: UInt8 { return 0b00000111 }

  /// The bitfield value of the prescale select field. It will be masked to the bit width of the field.
  @inlinable @inline(__always)
  public var bitfieldValue: UInt8 { return rawValue }

  /// Initializes a prescale select field from a bitfield value. It will be masked to the bit width of the field.
  @inlinable @inline(__always)
  public init(bitfieldValue: UInt8) {
    self.init(rawValue: bitfieldValue & Self.bitMask)!
  }
}

// Add aliases for approximate time in seconds when the oscillator is running at 1 MHz.

extension WatchdogTimeoutAt1MHz {
  /// Around 16ms (every 16K cycles)
  public static let around16ms = Self.every16KCycles

  /// Around 32ms (every 32K cycles)
  public static let around32ms = Self.every32KCycles

  /// Around 64ms (every 64K cycles)
  public static let around64ms = Self.every64KCycles

  /// Around 125ms (every 128K cycles)
  public static let around125ms = Self.every128KCycles

  /// Around 250ms (every 256K cycles)
  public static let around250ms = Self.every256KCycles

  /// Around 500ms (every 512K cycles)
  public static let around500ms = Self.every512KCycles

  /// Around 1s (every 1024K cycles)
  public static let around1s = Self.every1024KCycles

  /// Around 2s (every 2048K cycles)
  public static let around2s = Self.every2048KCycles
}