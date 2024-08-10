/// A ``TwiPeripheral`'s prescaler options. This controls how often the TWI clock is updated.
public enum TwiPrescaler: UInt8, Bitfield {
  case everyCycle = 0b00
  case every4Cycles = 0b01
  case every16Cycles = 0b10
  case every64Cycles = 0b11
}