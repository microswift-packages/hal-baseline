/// The input capture edge select.
public enum TimerInputCaptureEdgeSelect: UInt8, Bitfield {
  /// The input capture edge select is set to rising edge.
  case rising = 0
  /// The input capture edge select is set to falling edge.
  case falling = 1
}