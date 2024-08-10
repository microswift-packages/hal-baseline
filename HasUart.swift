
/// Indicates that a type has a default UART peripheral.
public protocol HasUart {
  /// The type of the default UART peripheral.
  associatedtype Uart: UartPeripheral
}
