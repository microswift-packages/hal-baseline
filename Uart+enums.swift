/// See ATMega328p Datasheet Section 20.4.1 and Table 20-9.
public enum UartParityMode: UInt8, Bitfield {
  case disabled = 0
  case even = 2
  case odd = 3
}

/// See ATMega328p Datasheet Table 20-10.
public enum UartNumberOfStopBits: UInt8, Bitfield {
  case one = 0
  case two = 1
}

/// See ATMega328p Datasheet Section 20.4 and Table 20-11.
public enum UartNumberOfDataBits: UInt8 {
  case five = 0
  case six = 1
  case seven = 2
  case eight = 3
  case nine = 7
}

/// See ATMega328p Datasheet Table 20-12.
// This is relative to the Transmitted Data Changed (Output of TxDn Pin)
// Recieved Data Sampled will be opposite of Transmitted Data Changed, Ex: Rising for TX is Falling for RX.
public enum UartClockPolarity: UInt8, Bitfield {
  case transmitOnRisingEdge = 0
  case transmitOnFallingEdge = 1
}

/// Mode Select (UMSELn1:0)
/// These bits select the mode of operation of the `UartPeriperhal`.
public enum UartModeSelect: UInt8, Bitfield {
  case asynchronous = 0
  case synchronous = 1
  case masterSPI = 3
}
