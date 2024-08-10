/// TWI 8-bit Slave Register Address.
public struct TwiSlaveRegisterAddress: RawRepresentable {
  /// The register's raw value.
  public let rawValue: UInt8

  /// Initializes the register with its raw value.
  @inlinable @inline(__always)
  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

extension TwiSlaveRegisterAddress: ExpressibleByIntegerLiteral {
  /// Initializes the register with an integer literal.
  @inlinable @inline(__always)
  public init(integerLiteral value: UInt8) {
    self.init(rawValue: value)
  }
}

extension TwiSlaveRegisterAddress: Strideable {
  @inlinable @inline(__always)
  public static func < (lhs: TwiSlaveRegisterAddress, rhs: TwiSlaveRegisterAddress) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }

  @inlinable @inline(__always)
  public func distance(to other: TwiSlaveRegisterAddress) -> Int {
    return Int(other.rawValue - self.rawValue)
  }

  @inlinable @inline(__always)
  public func advanced(by n: Int) -> TwiSlaveRegisterAddress {
    return TwiSlaveRegisterAddress(rawValue: UInt8(Int(self.rawValue) + n))
  }
}
