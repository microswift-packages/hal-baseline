/// TWI 7-bit Slave Address.
public struct TwiSlaveAddress : RawRepresentable {
  /// The bitfield's raw value.
  public let rawValue: UInt8

  /// Initializes the address with its raw value.
  @inlinable @inline(__always)
  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

extension TwiSlaveAddress: ExpressibleByIntegerLiteral {
  /// Initializes the bitfield with an integer literal.
  @inlinable @inline(__always)
  public init(integerLiteral value: UInt8) {
    self.rawValue = value
  }
}

extension TwiSlaveAddress {
  /// A general call address.
  /// This is used to send a general call or start condition to all connected slave devices.
  @inlinable @inline(__always)
  public static var generalCall: Self { 0x0 }
}

extension TwiSlaveAddress {
  /// A SLA+R (read) value.
  @inlinable @inline(__always)
  public var read: TwiSlaveAddressRW { .init(address: self, .read) }

  /// A SLA+W (write) value.
  @inlinable @inline(__always)
  public var write: TwiSlaveAddressRW { .init(address: self, .write) }
}
