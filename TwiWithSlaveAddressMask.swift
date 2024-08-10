/// A ``TwiPeripheral`` which can be configured to operate in slave mode with a slave address mask.
public protocol TwiWithSlaveAddressMask: TwiPeripheral {  
  /// The Two Wire Interface peripheral's slave address mask.
  @inlinable @inline(__always)
  static var slaveAddressMask: TwiSlaveAddressMask { get set }
}