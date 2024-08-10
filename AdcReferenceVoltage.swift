/// The reference voltage for the ADC.
public enum AdcReferenceVoltage: UInt8, Bitfield {
  case aref = 0x0
  case avcc = 0x1
  case internal1_1V = 0x3
}
