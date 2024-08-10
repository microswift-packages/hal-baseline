/// Indicates that a type has a default TWI peripheral.
public protocol HasTwi {
  /// The type of the default TWI peripheral.
  associatedtype Twi: TwiPeripheral
}
